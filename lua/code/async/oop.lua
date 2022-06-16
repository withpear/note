local function is_declaration(v)
    return getmetatable(v) and getmetatable(v).is_declaration
end

local function is_class(v)
    return getmetatable(v) and getmetatable(v).is_class
end

local function is_instance(v)
    return getmetatable(v) and getmetatable(v).is_instance
end

local function is_interface(v)
    return getmetatable(v) and getmetatable(v).is_interface
end

local function new_declaration(parent, prototype)
    assert(is_declaration(parent) or parent == nil)
    assert(type(prototype) == "table")
    return setmetatable({}, {
        __newindex = prototype,
        is_declaration = true,
        parent = parent,
        prototype = setmetatable(prototype, {
            __index = parent and getmetatable(parent).prototype or nil,
        }),
    })
end

local function new_instance(class)
    assert(is_class(class))
    return setmetatable({}, {
        __index = getmetatable(class).prototype,
        is_instance = true,
        class = class,
        index = nil,
    })
end

local function new_class(declaration, parent, prototype)
    assert(is_declaration(declaration))
    assert(is_class(parent) or parent == nil)
    assert(type(prototype) == "table")
    return setmetatable({}, {
        __index = getmetatable(declaration).prototype,
        __newindex = function (class, key, value)
            if type(value) ~= "function" then
                prototype[key] = value
                return
            end
            prototype[key] = function(self, ...)
                local index = getmetatable(self).index
                getmetatable(self).index = class
                local result = value(self, ...)
                getmetatable(self).index = index
                return result
            end
        end,
        __call = function (class, ...)
            local ins = new_instance(class)
            ins:construct(...)
            return ins
        end,
        is_class = true,
        declaration = declaration,
        parent = parent,
        prototype = setmetatable(prototype, {
            __index = parent and getmetatable(parent).prototype or nil,
        }),
    })
end

local Class = new_declaration(nil, {})

function Class:extend(parent)
    assert(is_class(parent))
    assert(parent:subtype_of(getmetatable(self).parent))
    getmetatable(self).parent = parent
    setmetatable(getmetatable(self).prototype, {
        __index = getmetatable(parent).prototype,
    })
    return self
end

function Class:subtype_of(supertype)
    if is_class(supertype) then
        if self == supertype then
            return true
        end
        local parent = getmetatable(self).parent
        return parent and parent:subtype_of(supertype)
    end
    if is_interface(supertype) then
        local prototype = getmetatable(self).prototype
        for k, v in pairs(supertype) do
            if type(v) == "function" and prototype[k] == nil then
                return false
            end
        end
        for i, parent in ipairs(getmetatable(supertype).parents) do
            if not self:subtype_of(parent) then
                return false
            end
        end
        return true
    end
    assert(false)
end

local Object = new_class(Class, nil, {
    _super = nil,
})

function Object:construct()
end

function Object:instance_of(supertype)
    assert(is_class(supertype) or is_interface(supertype))
    return getmetatable(self).class:subtype_of(supertype)
end

function Object:super()
    if self._super ~= nil then
        return self._super
    end
    self._super = setmetatable({}, { 
        __index = function (tbl, key)
            local index = getmetatable(self).index
            local parent = getmetatable(index).parent
            local value = parent and getmetatable(parent).prototype[key] or nil
            if type(value) ~= "function" then
                return value
            end
            return function (tbl, ...)
                return value(self, ...)
            end
       end,
    })
    return self._super
end

function Object:class()
    return getmetatable(self).class
end

local Enum = new_declaration(Class,{
    _are_flags = false,
    _count = 0
})

function Enum:as_flags()
    rawset(self,"_are_flags",true)
    return self
end

function Enum:are_flags()
    return self._are_flags
end

function Enum:count()
    return self._count
end

function Enum:increment()
    rawset(self,"_count",self._count + 1)
    assert(not self:are_flags() or self:count() <= 64)
end

local Member = new_class(Enum,Object,{
    _ordinal=0
})

function Member:construct()
    self:class():increment()
    if self:class():are_flags() then
        self._ordinal = 1 << (self:class():count() - 1)
    else
        self._ordinal = self:class():count()
    end
    local metatable = getmetatable(self)
    metatable.__band = function (l, r)
        return self._ordinal & (l ~= self and l or r)
    end
    metatable.__bor = function (l, r)
        return self._ordinal | (l ~= self and l or r)
    end
end

function Member:ordinal()
    return self._ordinal
end

local Interface = setmetatable({}, {
    __newindex = function (interface, key, value)
        getmetatable(interface).prototype[key] = value
    end,
    prototype = {},
})

function Interface:extend(...)
    local parents = { ... }
    assert(#parents > 0)
    for i = 1, #parents do
        assert(is_interface(parents[i]), i)
    end
    getmetatable(self).parents = parents
    return self
end

function Interface:subtype_of(supertype)
    assert(is_interface(supertype))
    if self == supertype then
        return true
    end
    for i, parent in ipairs(getmetatable(self).parents) do
        if parent:subtype_of(supertype) then
            return true
        end
    end
    return false
end

local function new_interface()
    return setmetatable({}, {
        __index = getmetatable(Interface).prototype,
        is_interface = true,
        parents = {},
    })
end

return {
    is_class = is_class,
    is_instance = is_instance,
    is_interface = is_interface,
    new_class = function(prototype)
        assert(type(prototype) == "table" or prototype == nil)
        return new_class(Class, Object, prototype or {})
    end,
    new_enum = function(prototype)
        assert(type(prototype) == "table" or prototype == nil)
        return new_class(Enum,Member,prototype or {})
    end,
    new_interface = new_interface,
}
a = 1
print("_G:", a) --1

local _ENV = {
    a = 2,
    print = _ENV.print
}
print("_ENV:", a) --2

local a = 3
print("local:", a) --3

local function f()
    local _ENV = {
        a = 4,
    }
    return a
end
print("func:", f()) --3

-- -- 最外面的environment是_G
-- -- 每一个chunk的_ENV都是它上一层的environment
-- -- 在每个chunk中可以重新定义_ENV
-- -- 每个chunk的_ENV对于该chunk都是一个upvalue

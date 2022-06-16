
local function consumer(prod)
    while true do
        local status,value = coroutine.resume(prod)
        io.write(value,"")
        io.write("\n")
    end
end

local function producer()
    return coroutine.create(function ()
        while true do
            local x = io.read()
            coroutine.yield(x)
        end
    end)
end

--consumer(producer())

local function filter(prod)
    return coroutine.create(function ()
        while true do
            local status,value = coroutine.resume(prod)
            value = value .. "pl"
            coroutine.yield(value)
        end
    end)
end
consumer(filter(producer()))
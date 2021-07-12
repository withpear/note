local tablex = require("tablex")

local tab = {
    level = 1,
    attack = 10,
    hp = 100
}

local t = tablex.deepcopy(tab)
print(t == tab)
for k, v in pairs(t) do
    if type(v) == "table" then
        for key, value in pairs(v) do
            print(key, value)
        end
    else
        print(k, v)
    end
end

local tab = { "a", "b", "c"}
tab.a = nil
print(#tab) -- 0

-- local inp=io.input()
-- local a = inp:read()
-- local out=io.output()
-- for i = 1, 1000, 1 do
--     out:write(a)
-- end

local function foo()
    print("hello")
end
local num=0
local co =coroutine.create(function ()
    local inp=io.input()
    local a = inp:read()
    num = coroutine.yield(5)
    local out=io.output()
    out:write(a)
end)
coroutine.resume(co)
print(num)
foo()
coroutine.resume(co)
print(num)
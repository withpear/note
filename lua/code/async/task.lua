local unity = require("unity")
local M = {}

local function await_any(...)

end

local function await(f, ...)
    f(coroutine.running(), ...)
    coroutine.yield()
end

M.foo = function()
    local a = 10
    await(unity.TimeoutAsync, 2)
    unity.Log(a)
    await(unity.TimeoutAsync, 5)
    unity.Log(a * 2)
end

M.foo = co.async(function()
    local a = 10
    await(unity.TimeoutAsync, 2)
    unity.Log(a)
    await(unity.TimeoutAsync, 5)
    unity.Log(a * 2)
end)

-- local task = unity.TimeoutAsync(2)
-- await task

-- local t1 = unity.TimeoutAsync(2)
-- local t2 = unity.TimeoutAsync(5)
-- local t3 = unity.WhenAll(t1,t2)
-- await t3

local main = function()
    foo()
end

local bar = function() -- unity / lua function
    return task
end

local foo = co.async(function()
    co.await(qux())
end)

local qux = co.async(function()
    local a = 10
    co.await(bar())
    unity.Log(a)
    -- await(unity.TimeoutAsync, 5)
    -- unity.Log(a * 2)
end)

-- 在C#中
--[[
1. 创建qux coroutine的class
2. 创建qux_()
    2.0  创建TaskCompletionSource
    2.1  生成qux coroutine class的实例，通过constructor传递TaskCompletionSource，告知实例完成后调用source.SetResult()
    2.2  resume这个实例
    2.3  返回source.Task
--]]
-- 在Lua中,co.async 创建qux_()
--[[
1. 创建qux_()
    1.0 创建TaskCompletionSource
    1.1 生成coroutine的实例：local c = coroutine.create(function() qux();source.SetResult(); end)
    1.2 coroutine.resume(c)
    1.3 return source.Task
--]]


return coroutine.create(M.foo)
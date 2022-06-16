local co = require("co")
local unity = require("unity")

local TimeoutAsync = function(time) 
    local tcs = co.TaskCompletionSource()
    unity.Timeout(time, function(result) 
        tcs:SetResult(result)
    end)
    return tcs:GetTask()
end

local qux = co.async(function()
    local t1 = TimeoutAsync(2)
    local t2 = TimeoutAsync(5)
    local r = co.await(t2)
    unity.Log(r)
    local r1 = co.await(t1)
    unity.Log(r1)
end)

local foo = co.async(function()
    co.await(qux())
end)

local main = function()
    foo()
end

return main
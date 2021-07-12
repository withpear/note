local tablex=require("tablex")
-- 没有yield
-- local function printResult(a)
--     for i = 1, #a do
--         io.write(a[i], "")
--     end
--     io.write("\n")
-- end
-- local function permgen(a, n)
--     n = n or #a
--     if n <= 1 then
--         -- printResult(a)
--         return a                          -- todo
--     else
--         for i = 1, n do
--             a[n], a[i] = a[i], a[n]
--             permgen(a, n - 1)
--             a[n], a[i] = a[i], a[n]
--         end
--     end
-- end
-- permgen({1,2,3,4})


-- normal
-- local function permgen(a, n)
--     n = n or #a
--     if n <= 1 then
--         coroutine.yield()
--     else
--         for i = 1, n do
--             a[n], a[i] = a[i], a[n]
--             permgen(a, n - 1)
--             a[n], a[i] = a[i], a[n]
--         end
--     end
-- end
-- local co = coroutine.create(permgen)
-- local a = {1, 2, 3, 4}
-- while coroutine.resume(co, a) do
--     for i = 1, #a do
--         io.write(a[i], " ")
--     end
--     io.write("\n")
-- end

-- create iterator
local function permgen(a, n)
    n = n or #a
    if n <= 1 then
        local tb = tablex.deepcopy(a)
        coroutine.yield(tb)
    else
        for i = 1, n do
            a[n], a[i] = a[i], a[n]
            permgen(a, n - 1)
            a[n], a[i] = a[i], a[n]
        end
    end
end

local function enumerable(a)
    local co = coroutine.create(permgen)
    return function()
        local err, res = coroutine.resume(co, a)
        return res
    end

    -- -- use wrap
    -- return coroutine.wrap(function ()
    --     permgen(a)
    -- end)
end

local a = {1, 2, 3}

for p in enumerable(a) do
    print("---------")
    for i = 1, #p do
        io.write(p[i], " ")
    end
    io.write("\n")
end


local function printResult(a)
    for i = 1, #a do
        io.write(a[i], "")
    end
    io.write("\n")
end


-- local function permgen(a, n)
--     n = n or #a
--     if n <= 1 then
--         printResult(a)
--     else
--         for i = 1, n do
--             a[n], a[i] = a[i], a[n]
--             permgen(a, n - 1)
--             a[n], a[i] = a[i], a[n]
--         end
--     end
-- end

--permgen({1,2,3,4})

local function permgen(a, n)
    n = n or #a
    if n <= 1 then
        coroutine.yield(a)
    else
        for i = 1, n do
            a[n], a[i] = a[i], a[n]
            permgen(a, n - 1)
            a[n], a[i] = a[i], a[n]
        end
    end
end

local function permutations(a)
    local co =coroutine.create(function ()
        permgen(a)
    end)
    -- return function ()
    --     local code,res = coroutine.resume(co)
    --     return res
    -- end

    return coroutine.wrap(function ()
        permgen(a)
    end)
end

for p in permutations{1,2} do
    printResult(p)
end
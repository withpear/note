local function func()
    error({error = "input nil value!"})
end

local function handler(e)
    --print(debug.traceback())
    e.code = 10
    return e
end

local ok,err = xpcall(func, handler)
print(ok,err.code)
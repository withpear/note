local function func()
    error({error = "input nil value!"})
end

local function handler()
    --print(debug.traceback())
end

local isRun = xpcall(func, handler)
if isRun then
    print("OK")
end
print("running!")

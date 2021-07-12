local lib = require("lib")

local function run(code)
    local co = coroutine.create(function ()
        code()
        lib.stop()
    end) 
    coroutine.resume(co)
    lib.runloop()
end

local function putline(stream, line)
    local co = coroutine.running()
    local callback = function()
        coroutine.resume(co)
    end
    lib.writeline(stream, line, callback)
    coroutine.yield()
end

local function getline(stream,line)
    local co = coroutine.running()
    local callback = function(line)
        coroutine.resume(co,line)
    end
    lib.readline(stream, callback)
    local line = coroutine.yield()
    return line
end

local function func()
    local t={}
    local inp = io.input()
    local out = io.output()
    while true do
        local line = getline(inp)
        if line == "end" then
            break
        end
        t[#t+1]=line
    end

    for i = #t, 1, -1 do
        putline(out,t[i].."\n")
    end
end

run(func)

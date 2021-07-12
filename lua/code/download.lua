local socket = require("socket")

local function receive(connection)
    connection:settimeout(0) -- do not block
    local s, status, partial = connection:receive(2 ^ 10)
    if status == "timeout" then
        coroutine.yield()
    end
    return s or partial, status
end

local function download(host, file)
    local c = assert(socket.connect(host, 80))
    local count = 0 -- counts number of bytes read
    local request = string.format("GET %s HTTP/1.0\r\nhost: %s\r\n\r\n", file, host)
    c:send(request)
    while true do
        local s, status = receive(c)
        count = count + #s
        if status == "closed" then
            break
        end
    end
    c:close()
    print(file, count)
end

local tasks = {} -- list of all live tasks

local function get(host, file)
    -- create coroutine for a task
    local co =
        coroutine.wrap(
        function()
            download(host, file)
        end
    )
    -- insert it in the list
    table.insert(tasks, co)
end

local function dispatch()
    local i = 1
    while true do
        if tasks[i] == nil then -- no other tasks?
            if tasks[1] == nil then -- list is empty?
                break -- break the loop
            end
            i = 1 -- else restart the loop
        end
        if tasks[i]() then -- task finished?
            table.remove(tasks, i)
        else
            i = i + 1 -- go to next task
        end
    end
end
get("www.lua.org", "/ftp/lua-5.3.2.tar.gz")
dispatch() 
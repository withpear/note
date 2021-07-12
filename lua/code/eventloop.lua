-- framework
function main()
    initialize()
    runloop()
end

local readline_callbacks = {}

function runloop()
    while true do
        local buf
        os.readline(buf) -- 留下给开发者添加event的位置
        local e = os.readevent()
        if e == "close" then
            return
        else
            if e == "line" then
                for key, value in pairs(readline_callbacks) do
                    value(buf)
                end
            end
        end
    end
end

function readline(callback)
    table.insert(readline_callbacks, callback)
    return function() 
        for key, value in pairs(readline_callbacks) do
            if value == callback then
                readline_callbacks[key] = nil
                break
            end
        end
    end
end

-- user

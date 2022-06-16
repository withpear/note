local oop = require("oop")

local TaskAwaiter = oop.new_class({
    state = nil, 
})

function TaskAwaiter:construct(state)
    self:super():construct()
    self.state = state
end

function TaskAwaiter:IsCompleted()  
    return self.state.completed  
end

function TaskAwaiter:OnCompleted(continuation)
    if self.state.completed then
        continuation()
    else
        table.insert(self.state.continuations,continuation)
    end
end

function TaskAwaiter:GetResult()
    return self.state.result
end


local Task = oop.new_class({
    state = nil,
})

function Task:construct(state)
    self:super():construct()
    self.state = state
end

function Task:GetResult()
    return self.state.result
end

function Task:GetAwaiter()
    return TaskAwaiter(self.state)
end


local TaskCompletionSource = oop.new_class({
    state = nil,
    task = nil,
})

function TaskCompletionSource:construct()
    self:super():construct()
    self.state = {
        result = nil,
        completed = false,
        continuations = {},
    }
    self.task = Task(self.state)
end

function TaskCompletionSource:SetResult(value)
    self.state.completed = true
    self.state.result = value
    for _, continuation in pairs(self.state.continuations) do
        continuation()
    end
end

function TaskCompletionSource:GetTask()
    return self.task
end

local function await(task)
    local awaiter = task:GetAwaiter()
    if awaiter:IsCompleted() then
        return awaiter:GetResult()
    end
    local running = coroutine.running()
    awaiter:OnCompleted(function() 
        coroutine.resume(running) 
    end)
    coroutine.yield()
    return task:GetResult()
end

local function async(action)
    return function()
        local tcs = TaskCompletionSource()
        local c = coroutine.create(function() 
            action()
            tcs:SetResult()
        end)
        coroutine.resume(c)
        return tcs:GetTask()
    end
end

return {
    await = await,
    async = async,
    TaskCompletionSource = TaskCompletionSource,
}
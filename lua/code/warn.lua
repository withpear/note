local function func()
    warn("@input nil value!")
end
print(func())
local ok,warn = pcall(func)
print(ok,warn)
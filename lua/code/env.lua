local b = 3
local _ENV = {
    b = 1,
    print = _ENV.print
}
print(b) --3

a = 1
print("_G:", a) --1

local _ENV = {
    a = 2,
    print = _ENV.print
}
print("_ENV:", a) --2

local a = 3
print("local:", a) --3

local x = _ENV

local function f()
    print(_ENV == x)
    local _ENV = {
        a = 4
    }
    return a
end
print("func:", f()) --3
print(a)


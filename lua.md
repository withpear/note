# lua
##  _ENV与_G
5.1之前，全局变量存储在_G中。  
`a = 1` 相当于 `_G['a'] = 1`  
5.2之后，引入_ENV,_ENG不是全局变量，而是一个upvalue。  
`a = 1` 相当于 `_ENV['a'] = 1`
其次， `_ENV['G']`指向了_ENV本身。
在5.2中，`_G['a'] = 1`相当于`_ENV['G']['a'] = 1`，为兼容5.1，所以设置了`_ENV['G'] = _ENV`。

在函数定义前覆盖_ENV即可为函数定义设置一个全新的环境：
```lua
a = 2
function get_echo()
    local _ENV = {a = 3}
    return a
end

print(get_echo()) -- 3
```
1. __index的两种赋值
```lua
local x={}
local y={a=10}
-- 1.
y.__index=y
setmetatable(x,y)
print(x.a) --10

-- 2.
setmetatable(x,{__index=y})
print(x.a) --10
```
2. 多重继承的实现
```lua
local function search(k,plist)
	for i = 1, #plist do
		local v=plist[i][k]
		if v then return v end
	end
end
local function CreateClass(...)
	local parents={...}
	local c={}
	setmetatable(c,{
		__index=function (t,k)
			return search(k,parents)
		end
	})
	--c.__index=c
	function c:new(o)
		return setmetatable(o or {},{__index=c})
	end
	return c
end

local Named={}
function Named:getName()
	return self.name
end
function Named:setName(n)
	self.name=n
end
local Account={balance=0}
function Account:deposit(v)
	self.balance = self.balance + v
end
function Account:withdraw (v)
	if v > self.balance then error"insufficient funds" end
	self.balance = self.balance - v
end
   
local NameAccount=CreateClass(Account,Named)
local account=NameAccount:new{name="Paul"}
print(account:getName()) --Paul
account:deposit(10)
account:setName("pl")
print(account:getName()) -- pl
print(account.balance) --10
```
3. __index与__newindex
```lua
--Default
local mt={__index=function (t) return t.__  end}
local tab=setmetatable({__=10},mt)
print(tab.z)
--ReadOnly
local function ReadOnly(t)
	local proxy={}
	return setmetatable(proxy,{
		__index=t,
		__newindex=function (t,k,v)
			error("attempt to update a read-only table",2)
		end
	})
end
local b=ReadOnly{x=10,y=20}
print(b.x)
b.x=30
```
4. Weak Tables  
弱表：告诉lua什么对象才是垃圾对象自动删除回收  
key值弱引用: `setmetatable(t, {__mode = "k"});`  
value值弱引用: `setmetatable(t, {__mode = "v"});`  
key和value弱引用: `setmetatable(t, {__mode = "kv"});`  
```lua
local t={}
--setmetatable(t,{__mode="v"})
local key1={name="key1"}
t["a"]=key1

local key2={name="key2"}
t["b"]=key2

for key, value in pairs(t) do
	print(key,value.name)
end

key1=nil
key2=nil
collectgarbage()

for key, value in pairs(t) do
	print(key,value.name)
end

--输出
-- b       key2
-- a       key1
-- b       key2
-- a       key1
--添加setmetatable(t,{__mode="v"})后，输出
-- a       key1
-- b       key2
```

```lua
local t={}
--setmetatable(t,{__mode="k"})
local key1={name="key1"}
t[key1]=1

key1={name="key2"}
t[key1]=2

for key, value in pairs(t) do
	print(key.name,value)
end

collectgarbage()

for key, value in pairs(t) do
	print(key.name,value)
end
--输出
-- key1    1
-- key2    2
-- key1    1
-- key2    2
--添加setmetatable(t,{__mode="k"})后，输出
-- key1    1
-- key2    2
-- key2    2

```

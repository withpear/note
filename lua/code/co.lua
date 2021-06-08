local co 
local co9 =coroutine.create(function ()
    print(coroutine.status(co)) --normal
end)
co= coroutine.create(function ()
    print("hi")
    coroutine.resume(co9)
end)
coroutine.resume(co)




print(coroutine.status(co)) -- suspended  coroutine被创建后处于挂起状态

coroutine.resume(co)

print(coroutine.status(co)) -- dead

co = coroutine.create(function ()
    for i = 1, 3 do
        print("co", i)
        coroutine.yield()
    end
end)
coroutine.resume(co) -- co 1
print(coroutine.status(co)) -- suspended

coroutine.resume(co) -- co 2
print(coroutine.status(co)) -- suspended

coroutine.resume(co) -- co 3
print(coroutine.status(co)) -- suspended

coroutine.resume(co) -- prints nothing  coroutine内部结束循环并返回
print(coroutine.status(co)) -- dead

--resume在保护模式下运行，当coroutine内部发生错误时，不会抛出错误，只会将错误信息返回
print(coroutine.resume(co)) -- false   cannot resume dead coroutine. 


-- 1. main function 没有yield，调用resume额外的参数传递给main function作为参数
local co1 = coroutine.create(function (a,b,c)
    print("co", a, b, c + 2)
end)
coroutine.resume(co1, 1, 2, 3) -- co 1 2 5

-- 2. main function中有yield. 传递给yield的参数都被返回。resume返回值除了true/false外，还有传递给yield的参数
local co2 = coroutine.create(function (a,b)
    coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co2, 20, 10)) -- true 30 10 
print("co2 ",coroutine.status(co2))

-- 3. yield把额外的参数返回给对应的resume
local co3 = coroutine.create(function (x)
    print("co-a:", x)
    print("co-b:", coroutine.yield())
end)
coroutine.resume(co3, "hi") -- co-a: hi
coroutine.resume(co3, 1, 2) -- co-b: 1, 2

-- 4. 当coroutine结束时，main function的返回值都被传递给相应的resume
local co4 = coroutine.create(function ()
    return 4, 5
end)
print(coroutine.resume(co4)) -- true 4 5

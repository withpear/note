# require load loader open searcher 联系

 调用require(name)的时候，require首先找registry.global.package.loaded[name],若有值则直接返回该值；
    若没有，然后require foreach  registry.global.package.searchers ，
    就像是loader = searcher(name),假如loader不为null，那么 result = loader(name),
    然后registry.global.package.loaded[name] = result，然后返回result

## require C 模块或者 lua 模块
```lua
function require(name)
    local result = registry.global.package.loaded[name] 
    if result ~= nil then 
        return result
    end
    -- lua自带4个searcher： 
    -- 1. loader = registry.global.package.preload[name],若loader不为nil，则返回loader,":preload:"；
    -- 2. 如果path = registry.global.package.searchpath(name, registry.global.package.path) ，若path不为nil，则返回registry.global.loadfile(path),path
    -- 3. 如果path = registry.global.package.searchpath(name, registry.global.package.cpath) ，若path不为nil，(假设是windows c++)LoadLibrary(path),然后返回luaopen_NAME,path
    -- 4. 和3差不多，只不过支持name是a.b.c这种形式
    --    2，3，4仅仅支持在电脑端文件系统使用，在手机端无法使用
    
    -- 自定义searcher
    -- 找到匹配Name.lua的Addressable，如果找到，那么加载这个Addressable，然后返回lua_loadstring(content)
    for k, searcher in registry.global.package.searchers do
        local loader,data = searcher(name)
        if loader ~= nil then
            result = loader(name,data)
            registry.global.package.loaded[name] = result
            return result,data
        end
    end
    error("not found")
end
```
## 添加 C Module
```lua
function luaopen_XXX() -- c function
    return {
        f1 = function() end,
        f2 = function() end
    }
end
```

```lua
function requiref(name,open,glb)
    local result = open()
    registry.global.package.loaded[name] = result
    if glb then
        registry.global[name] = result
    end
end
```

## 添加Lua Module 
Lua Module不像C Module需要提前被添加到loaded里面去，而是在runtime的时候若被require则通过searcher找到合适的loader，然后loader会返回一个module，并添加到loaded里面去，并返回。
具体添加过程参见上面的 require function里的foreach部分
虽然Lua Module寻找过程是runtime,但是可以提前添加searcher，然后这个searcher会返回Lua_load或 LuaL_loadfile或 自定义LoadFromAddressble()

如果component手动调用loader,那么10个component就会调用10次loader
如果component调用require,那么require > cache(找到返回结果) > searcher > loader > 加入cache， 这样loader只会被调用一次，其它9次都是从cache里获取缓存结果


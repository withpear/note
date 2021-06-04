# 错误处理

* Lua有一套错误处理系统，类似于#C里的exception

    * Lua API 使用 error 抛出错误 ， C API使用 lua_error 抛出错误

    * Lua框架的API抛出的错误的种类是string，用户可以抛出任何类型的错误

    * 使用pcall执行函数，函数内一旦发生错误，代码将终止运行，pcall会返回LUA_ERROR错误代码和错误对象

    * 直接执行函数或在C中使用lua_call执行函数，函数内一旦发生错误，程序将终止运行

    * 使用xpcall执行函数，作用类似pcall，但可传递一个 message handler 在错误发生时调用
        ```lua
        local function func()
            error({error = "input nil value!"})
        end

        local function handler(e)
            e.code = 10
            return e
        end

        local ok,err = xpcall(func, handler)
        print(ok,err.code) -- false,10
        ```

* Lua有一套警告处理系统

    * Lua API 使用 warn 抛出警告 ， C API使用 lua_warning 抛出警告

    * C API 使用lua_setwarnf设置警告函数用来在警告发生时调用

    * 抛出警告不会中断程序执行
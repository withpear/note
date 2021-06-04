# 环境与全局环境
* Lua中的每个function可以当作是一个closure，它可以捕捉外部作用域的变量
    ```lua
    local a = 1
    function f()
        print(a) -- 1
    end
    f() 
    ```
* 在全局作用域中，有一个预定义的全局变量table: _ENV
* Lua在加载chunk的过程中，会把没有被定义的变量 var 转换成 _ENV.var
  第一步翻译(在加载过程中)，第二步运行
    ```lua
    a = 10
    local b = 20
    function f()
        print(a) -- 10
        print(b) -- 20
    end
    f()
    ```
  以上代码被转换为 
    ```lua
    _ENV.a = 10
    local b = 20
    function f()
        print(_ENV.a) -- 10
        print(b) -- 20
    end
    f()
    ```
* global environment被存储在C registry中(registry.LUA_RIDX_GLOBALS = _G)

* 虽然系统提供了全局的_ENV(global environment)，但也可以定义local _ENV (local environment)

* 即使定义了local _ENV, 也可以通过_G获取全局的global environment

* 所有标准库都被包含在global environment中


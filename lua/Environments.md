# 环境与全局环境
* _ENV: 每个被编译的Lua chunk都有一个upvalue名为 _ENV, _ENV的值称为environment
    * 任何未声明的free name(除了_ENV) var都会内部翻译成_ENV.var
    ```lua
    a = 1 -- 相当于 _ENV.a = 1
    ```
    * 每一层chunk的_ENV默认都是它上一层chunk的_ENV, 除非在chunk内有重新定义_ENV

* _G: Lua 默认的全局环境，值为在 C registry 中 key 为 LUA_RIDX_GLOBALS所对应的value
    * 当Lua加载chunk时，该chunk的_ENV默认为_G，可通过load或loadfile指定_ENV
    * 默认 _G 仅包含Lua标准库中的所有函数和变量

```lua

```

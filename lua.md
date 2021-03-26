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

# 值与类型
* Lua中变量没有类型，只有值有。C#中变量和值都有类型。
* 在Lua中**所有**值都是first-class。 Lua中一个function可以当作参数传递给另一个function。
* Lua中有8种类型： nil, boolean, number, string, function, userdata, thread, table。
* 在Lua中表示条件错误只有两个值：nil和false，其它值均为正确（0）。
* 只有在table中，nil表示删除这个key;相反local ...
    ```lua
    local a = nil
    local function b()
        a = 10
    end
    b()
    print(a) --10
    ```
  注意：a=nil时，相当于_G.a = nil

* number类型有两种内部表现方式：int和float;  
  * 标准Lua使用64位整数（范围：-2^63 ~ 2^63-1）和64位浮点数，也可把Lua编译成32位整数(范围：-2^31 ~ 2^31-1)和32位浮点数;   
  * 超出int范围的值会变成科学计数法;  --todo
  * Lua内部会按规则自动将number类型转换int或float类型。
    
* string类型是不可变byte序列，string中可包含任意8位的值(0 ~ 2^8-1); 
  * string既可以是binary string(与编码无关，如"\0\1")，也可以是text string(如"hello");任何string的长度都是int类型。
    ```lua
    local s1 = "\0\1" 
    local s2 = "hello"
    ```

* Lua里function有两类： Lua function 和 C function

* userdata类型表示一段内存
  * userdata分为两类： full userdata 和 light userdata
  * full userdata表示的内存由Lua所分配，并且可以由metatable定义额外的操作
  * light userdata表示的内存由用户手动分配（malloc）
  * userdata由C Lua API创建和修改，无法通过Lua chunk所...
  * userdata类型是一个引用类型

* Lua thread实际上是一个coroutine，就算系统只有一个hardware thread,它也支持多个coroutines
  * thread类型是一个引用类型


* table类型是Dictionary
  * key可以是任何种类（除了nil和NaN），索引的格式为a[key]，当key为string时候,可以写成 a.key
  * value可以是任何种类（除了nil）。当value为nil时，表示删除table中该元素
  * table可表示ordinary arrays, lists, symbol tables, sets, records, graphs, trees
  * table类型是一个引用类型
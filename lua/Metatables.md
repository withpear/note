# 元表与元方法

* meatatable 是一个Lua table, 用于定义一个值在特定操作下的行为
    
    * Lua中每个值都可以有一个metatable， 使用getmetatable(value)获取metatable， 使用setmatatble(value)定义或替换metatable

    *  最好先创建好一个完整的metatable，然后再设置为某个值的metatable

    * metatable 类似于一个容器，其中的每一个条目都定义了一个行为，条目的key由双下划线前缀加字符串组成，value可以是一个function或一个callable value。

    * metatable也可以包含自定义的值，与行为无关。

    * 每一种值类型和function类型都共享一个metatable，table和 full userdata可以共享metatable，也可以有独立的metatable


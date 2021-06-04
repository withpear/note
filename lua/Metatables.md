# 元表与元方法

* Lua中每个值都可以有一个metatable用于定义在特定操作下的行为

    * 可以使用 getmetatable 获取元表， 使用 setmetatable 设置新的元表

    * 元表中的事件的key由双下划线加字符串组成，对应的value叫做 metamethod

    * Lua中定义了一系列元表可以控制的事件

        * __add: 非数值的相加会调用该元方法

        * __index: 当table不存在或table中不存在传递的key值时被调用

        * __call: 当要调用一个非函数的值时触发该元方法
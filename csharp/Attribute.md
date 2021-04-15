# Attribute 
自定义特性基类


## AttributeUsageAttribute 
声明一个Attribute的使用范围和使用原则。
* AttributeTargets  
 指定可应用属性的应用程序元素，允许按位组合成员值  
* AllowMultiple 
 若AllowMultiple 参数设置为 true，则返回特性可对单个实体应用多次    
 默认为false  
 ```c#

        [Inherited("b")]
        [Inherited("a")]
        public virtual void MethodA() { }
 ```
* Inherited
 若Inherited 设置为 false，则该特性不由从特性化的类派生的类继承    
 默认为true    
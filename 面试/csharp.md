# CSharp
## 1. 项目，解决方案，程序集，命名空间区别
* **项目(Project)**  
在VS中，点击`File->New->Project`创建新项目，可为该项目创建一个新的解决方案，也可将该项目添加到当前解决方案中。每个项目都必须属于某个解决方案。  
项目可以表现为多种类型，例如控制台应用程序，Windows应用程序，类库（Class Library）等，经过编译，应用程序会编译成.exe文件，其余的会编译成.dll文件。

* **解决方案（Solution）**  
当创建项目时，该项目同时还属于一个解决方案。在解决方案中添加项目，需通过`File->New->Project`添加。
一般复杂的软件由多个模块组成，往往需要多个项目，每个项目实现不同的功能，再将它们组合起来，就行成了一个完整的解决方案。  
解决方案类似一个容器，用来存放项目，解决方案创建后会生成一个.sln文件。   

* **程序集（Assembly）**  
一组编译好的程序的集合体，里面有若干个模块(Module)，资源文件以及程序集清单（Manifast）。dll是程序集的物理表现形式，一个项目可以编译成若干个程序集，多个程序也可编译成一个程序集。  
通俗来说，一个项目就是一个程序集。  
从设计角度来说，一个程序集也可看作一个模块（Module）,或一个包（Package）,因此一个程序集也可以体现为一个dll文件或一个exe文件。  

* **命名空间(Namespace)**  
引入命名空间主要是为了避免在一个项目中，可能会存在相同类名的冲突。 命名空间是类的逻辑组织形式，程序集是类的物理组织形式。命名空间是程序集内部相关联类的一个分组。  

## 2. public、protected、private、internal区别
* **public** 
访问不受限制。同一程序集中的任何代码或引用该程序集的其它程序集都可以访问该类型或成员。 

* **protected** 
在类的内部或在派生类中访问。

* **private** 
类成员(字段和方法)的默认访问级别。只能在类的内部访问。

* **internal** 
只能在同一个程序集（Assembly）中才能访问。

## 3. Class,Interface,Struct,Enum,Abstract的默认访问权限
Note: 类(class)或结构(struct)如果不是在其它类或结构中的话，它的访问类型要不就是internal, 要不就是public。 如果它在其它类或结构中的话，则可以为private 或protected等  

* **Class**   
class的访问修饰符只有public和internal  
class的默认访问级别为 **internal**  
class成员(字段和方法)的默认访问级别为 **private**  
非抽象类的默认构造方法的默认访问级别为 **public**  
抽象类的默认构造方法的默认访问级别为 **protected**  
自定义构造函数若未标明访问权限，默认为**private**  

* **Interface**   
Interface的访问修饰符只有public和internal  
Interface的默认访问级别为 **internal**  
成员（方法和属性（有get，set方法））的默认访问级别为 **public**  

* **Struct**   
Struct的访问修饰符为public和internal
Struct的默认访问级别为 **internal**  
成员的默认访问级别为 **private**  

* **Enum**   
Enum的默认访问级别为 **public**  
Enum成员的默认访问级别为 **public**  

* **Abstract**   
Abstract类的默认访问级别为 **internal**  
Abstract类中成员的默认访问级别为 **public**  ，不能定义为 **private**  

## 4. 接口和抽象类的区别
相同之处： 
1. 不能被实例化
2. 包含未实现的方法声明
3. 派生类必须实现未实现的方法。抽象类是抽象方法，接口则是所有成员  

不同之处：
1. 接口支持多继承，抽象类不支持。接口用于规范，抽象类用于共性，所以抽象类只能单继承，而接口可以实现多
```c#
//多继承
interface IFoo{}
interface IBar{}
class Qux:IFoo,IBar{}
```
2. 接口中只能声明方法，属性，事件，索引器。不能包含其它任何成员例如静态成员，字段，常量，构造函数。  
抽象类内可以定义字段，属性，包含实现的方法。
```c#
delegate void Delegate();
interface I<T>
{
    void Say();//方法
    List<T> list { get; set; }//属性
    event Delegate Dg;//事件
    T this[int i] { get;set; }//索引器
}
```
```c#
 //不能使用sealed修饰，sealed为不可继承
    abstract class F<T>
    {
        public abstract void Say();
        //public abstract string birth;//字段不允许
        //abstract string birth { get; set; }//private访问权限不允许
        //public static abstract void SayHi();//不能添加static修饰符
        //public virtual abstract void SayHi();//不能标记为virtual，因为默认就是虚方法
        public abstract string name { get; set; }//abstract不能修饰字段，可以修饰属性
        protected abstract T this[int i] { get; set; }//abstract索引器
        //abstract类可有字段，方法等，可被派生类调用
        public int age;
        private string date;
        public static int id;
        public string GetDate()
        {
            return date;
        }
    }
```

## 5. abstract 与 virtual的区别
相同之处：  
1. 都是用于修饰父类方法，通过覆盖父类的定义，让子类重新定义  
2. 都不能被private访问级别修饰  
不同之处：     
1. abstract修饰的方法不能有实现，virtual修饰的方法必须有实现
2. abstract修饰的方法必须被子类重写，virtual修饰的方法可以被子类重写
3. 如果类成员被abstract修饰，那么类也必须被abstract修饰，且无法创建该abstract类的实例
```c#
    public abstract class Foo
    {
        //private abstract void Func();    abstract和virtual修饰的方法不能由private修饰
        //private virtual void Bar() { }

        public abstract void Func1();
        protected abstract void Func2();
        public virtual void Bar() { }//virtual修饰的方法必须有实现体
        protected virtual void Qux() { }
    }

    public class Child : Foo
    {
        //abstract修饰的方法必须被子类重写
        public override void Func1()
        {
        }

        protected override void Func2()
        {
        }

        //virtual修饰的方法可以被子类重写
        public override void Bar()
        {
            base.Bar();
        }
        protected override void Qux()
        {
            base.Qux();
        }
    }
```

## 6. const和readonly
1. const默认为静态的，不能添加static，只能由类型访问。 readonly默认为非静态，由实例对象访问，可使用static将readonly字段定义为静态成员
```c#
    class Foo
    {
        //public static const string name; // const不能与static同时使用，const默认为静态的
        public const int age = 0; //const字段声明必须初始化

        public readonly string name;
        public static readonly int id; //readonly可使用static
    }
    class Program
    {
        static void Main(string[] args)
        {
            Foo foo = new Foo();
            Console.WriteLine(foo.name);//readonly由实例对象访问
            Console.WriteLine(Foo.id);//访问静态只读字段
            Console.WriteLine(Foo.age);//const默认为静态，由类型访问
        }

    }
```
2. const字段必须在声明时初始化且表达式不能包含变量，readonly不用
```c#
        static int C;
        const int A = 10 + C; //错误，A必须为常量

        const int D = 10;
        const int E = D * 10;//可以有表达式
```

3. const修饰的是静态常量，静态常量是指编译器在编译时会对常量进行解析，编译器不在乎字段定义先后顺序；readonly修饰的是动态常量，动态常量的值只在运行的那一刻才获得，编译期间标识为常量，这样动态常量不必在声明时初始化。
```c#
        const int E = D * 10;
        const int D = 10;

        static readonly int F = G * 10;
        static readonly int G = 10;//不加static会报错

        public static void Main(string[] args)
        {
            Console.WriteLine("E is {0},D is {1} ", E, D);// 100,10

            Console.WriteLine("F is {0},G is {1} ", F, G);// 10,10
        }

```

4. readonly只能声明在类中，const常量既可以声明在类中也可以声明在函数体中
5. cons常量只能被声明为简单的值类型和string类型，readonly只读字段可以是任意类型


## 7. delegate,event,EventHandler
delegate：要把一个方法作为实参传入其它方法的形参时，该形参需要用到委托。  
委托是一个函数指针类型。当实例化委托时，委托对象会指向某一个函数，实际就是将该函数的地址赋值给该委托对象，则可通过该委托调用该函数了。  
在delegate定义在类外部修饰符必须是：public或inernal(默认)，在类内部则可使用其它修饰符。  
```c#
public delegate string Transformer(int n);
public class Program{
    public string Bar(int num)
    {
        Console.WriteLine(num.ToString());
    }
    public void Test(int n,Transformer trans){
        trans(n);
    }
    public void Main(){
        Test(10,Bar);
    }
    //多播
    
            Transformer trans = null;
            trans += Foo;
            trans += Qux;
            trans();
}
```
event: 事件是一种特殊的委托,
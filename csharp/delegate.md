# Delegate
委托：委托是一个对象，它知道如何调用一个方法。  
委托类型之间互不相容，即使方法签名一样；
如果委托实例拥有相同的方法目标，那么委托实例就认为是相等的。
```c#
delegate void D();
...
D d1 = Method1;
D d2 = Method2;
Console.WriteLine(d1==d2);//true
```
## 实例方法目标和静态方法目标
当一个实例方法被赋值给委托对象的时候，这个委托对象不仅要保留对方法的引用，还要保留方法所属实例的引用，System.Delegate的Target属性就代表这个实例。如果引用的是静态方法，则Traget属性的值为null.
```c#
    class Test{
        static void Main(){
            X x = new X();
            ProgressReporter p = x.InstanceProgress;
            p(99);
            Console.WriteLine(p.Target == x);//True
            Console.WriteLine(p.Method);//Void InstanceProgress(Int32)
        }
    }
    public delegate void ProgressReporter(int percentComplete);
    public class X
    {
        public void InstanceProgress(int percentComplete) => Console.WriteLine(percentComplete);
    }
```

## 泛型委托类型
委托类型可以包含泛型类型参数。
```c#
public delegate T Tranformer<T>(T arg) // Func<T,T>
```
###  Action & Func
Action至少0个参数，至多16个参数，无返回值;  
Func至少0个参数，至多16个参数，根据返回值泛型返回。必须有返回值，不可void。  
## 委托与接口
委托可以解决的问题，接口都可以解决。  
更适合使用委托的情况，当下列条件之一满足时：
1. 接口只能定义一个方法
2. 需要多播功能
3. 订阅者需要多次实现接口

# Event
事件是一种结构，为了实现广播者/订阅者模型，它只暴露了所需的委托特性的部分子集。  
事件的主要目的就是防止订阅者之间互相干扰。

# 标准事件模式
## System.EventArgs
## EventHandler<T>
public delegate void EventHandler<TEventArgs> (object source, TEventArgs e) where TEventArgs:EventArgs


# Lambda表达式
被捕获的变量：
被捕获的变量是在委托被实际调用时才被计算，而不是在捕获的时候。
```c#
int factor=2;
Func<int,int> multiplier = n=>n*factor;
factor=10;
Console.WriteLine(multiplier(3)); //30
```
Lambda表达式本身也可以更新被捕获的变量
```c#
int seed =0;
Func<int> natural = ()=>seed++;
Console.WriteLine(natural());//0
Console.WriteLine(natural());//1
Console.WriteLine(seed);//2
```
被捕获的变量的生命周期会被延长到和委托一样
```c#
static Func<int> Natural(){
    int seed=0;
    return ()=>seed++;
}
static void Main(){
    Func<int> natural=Natural();
    Console.WriteLine(natural());//0
    Console.WriteLine(natural());//1
}
```

### 匿名方法 vs Lambda表达式
匿名方法对比Lambda表达式缺少三个特性：  
1. 隐式类型参数  
2. 表达式语法（只能是语句块）  
3. 编译表达式树的能力，通过赋值给Expression<T>  

匿名方法：
```C#
delegate int Transformer(int i);

Transformer sqr = delegate(int x){return x*x;};
Console.WriteLine(sqr(3));//9
```
Lambda表达式：
```c#
Transformer sqr = (int x) => {return x*x;};
Transformer sqr = x => x*x;
```
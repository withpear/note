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

## 委托与接口
委托可以解决的问题，接口都可以解决。  
更适合使用委托的情况，当下列条件之一满足时：
1. 接口只能定义一个方法
2. 需要多播功能
3. 订阅者需要多次实现接口
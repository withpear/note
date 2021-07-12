# Thread
当在主线程中开启一个线程后，主线程后续的操作与分线程内的操作 并行执行
```c#
int Main()
{
    new Thread(() => {
        for (int i = 0; i < 1000; i++)
        {
            Console.Write("y");
        }
        //thread构造函数传入的委托执行结束，则线程结束，无法重启
    }).Start();
    for (int i = 0; i < 1000; i++)
    {
        Console.Write("x");
    }
}
// 主线程与分线程并行执行： xxxxyyyyxxyyyyx....  
```

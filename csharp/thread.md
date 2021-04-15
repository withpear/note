# Thread
```c#
    class Program
    {
        static void Main(string[] args)
        {
            Thread.CurrentThread.Name = "Main Thread...";

            Thread t = new Thread(WriteY);
            t.Name = "Y Thread...";
            t.Start();

            Console.WriteLine(Thread.CurrentThread.Name);
            for (int i = 0; i < 1000; i++)
            {
                Console.Write("x");
            }
        }

        static void WriteY()
        {
            Console.WriteLine(Thread.CurrentThread.Name);
            for (int i = 0; i < 1000; i++)
            {
                Console.Write("y");
            }
        }
    }
```
在单核计算机中，操作系统必须为每个线程分配时间片来模拟并发，从而会导致重复的x块和Y块。  
在多核或多处理器计算机中，这两个线程可以真正的并行执行，但由于控制台处理并发请求机制的微妙性，也可能会得到重复的x块和y块。  

线程抢占：线程的执行与另外一个线程代码的执行交织的那一点。  
线程属性：  
线程一旦开始执行，IsAlive就是true,线程结束就是false;  
线程结束的条件就是：线程构造函数传入的委托结束了执行；  
线程一旦结束，无法重启；  
每个线程都有Name属性，通常用于调试，Name只能设置一次，以后更改会抛出异常；  
静态的Thread.CurrentThread属性会返回当前执行的线程。  


## Join
调用Join方法，等待另一个线程的结束。
```c#
 public static void MainThread()
        {
            Thread t = new Thread(WriteY);
            t.Start();
            t.Join();
            Console.WriteLine("Thread t has ended.");
        }

        static void WriteY()
        {
            for (int i = 0; i < 1000; i++)
            {
                Console.Write("y");
            }
        }
```
可以为Join方法设置超时，如果返回true,则线程结束；如果返回false,则线程超时。  
```c#
Thread t = new Thread(WriteY);
            t.Start();
            if (t.Join(200))// 可以是毫秒，或者使用TimeSpan
            {
                Console.WriteLine("Thread t has ended.");
            }
            else
            {
                Console.WriteLine("Thread t was timeout.");
            }
```

## Sleep
Thread.Sleep()方法会暂停当前的线程，并等待一段时间。可传入毫秒或TimeSpan。
```c#
for (int i = 0; i < 5; i++)
            {
                Console.WriteLine("Sleep for 2 seconds.");
                Thread.Sleep(2000);
            }

            Console.WriteLine("Main Thread exits.");
```
Thread.Sleep(0)会导致线程立即放弃本身当前的时间片，自动将CPU移交给其它线程。
Thread.Yield()做同样的事情，但是它只会把执行交给同一处理器上的其他线程。（代码中不要使用，会有bug）
当等待Sleep和Join的时候，线程处于阻塞的状态。

## 阻塞
如果线程的执行由于某种原因导致暂停，那么久认为该线程被阻塞了。
可通过ThreadState属性（flag枚举）判断线程是否处于阻塞状态，通过按位的形式，可以合并数据的选项。
```c#
var state =  ThreadState.Unstarted | ThreadState.Stopped | ThreadState.WaitSleepJoin;
```

## 解除阻塞
当遇到下列四种情况就会解除阻塞：
1. 阻塞条件被满足；
2. 操作超时（如果设置了超时）；
3. 通过Thread.Interrupt()进行打断；
4. 通过Thread.Abort()进行中止。
当线程阻塞或解除阻塞时，操作系统将执行上下文切换。

## I/O-bound   CPU-bound
* 一个花费大部分时间等待某事发生的操作称为I/O-bound
* 一个花费大部分时间执行CPU密集型工作的操作称为Compute-bound

## 线程安全
在读取和写入共享数据时，通过使用一个互斥锁保证线程安全。
c#使用lock语句进行加锁。
当两个线程同时竞争一个锁的时候（锁可以基于任何引用类型对象），一个线程会等待或阻塞，直到锁变成可用状态。
```c#
 static bool _done;
        static readonly object _locker = new object();

        public static void MainTest()
        {
            new Thread(Go).Start();
            Go();
        }

        static void Go()
        {
            lock (_locker)
            {
                if (!_done)
                {
                    Console.WriteLine("Done");
                    _done = true;
                }
            }
        }
```

捕获的变量
```c#
static void Main(){
    for (int i = 0; i< 10; i++>){
        //i在循环的整个生命周期内指向的是同一个内存地址
        //每个线程对Console.Write（）的调用都会在它运行时进行修改
        new Thread(()=>Console.Write(i)).Start();//6668882317

        //解决方案
        int temp=i;
         new Thread(()=>Console.Write(temp)).Start();//8127394506 顺序不一致
    }
}
```

## 前台和后台线程
默认情况下，手动创建的线程就是前台线程；
只有前台线程运行，那么应用程序就会一直处于活动状态，但后台程序却不行。
一旦所有的前台线程停止，那么应用程序就停止了，任何的后台线程也会突然终止。
可通过IsBackground判断线程是否是后台线程，也可设置线程为后台线程。
当进程以这种形式终止时，后台线程执行栈中的finally块就不会被执行。


## 优先级
线程的优先级（Thread的Priority属性）决定了相对于操作系统中其它活跃线程所占的执行时间。
优先级分为：
enum ThreadPriority{Lowest,BelowNormal,Normal,AboveNormal,Highest}


## 线程池
不可以设置池线程的Name;
池线程都是后台线程；
最简单现实的在线程池运行代码是就是Task.Run
```c#
Task.Run(()=> Console.WriteLine("Hello from the thread pool"));
```
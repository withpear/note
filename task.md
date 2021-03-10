# Task

## Thread的问题
Thread是用来创建并发的一种低级别工具，它有一些限制：
* 开始线程时可以方便的传入数据，但当Join的时候，很难从线程获得返回值。（可能需要设置一些共享字段，如果操作抛出异常，捕获和传播异常很麻烦）
* 无法告诉线程在结束时开始做另外的工作，必须进行Join操作（在进程中阻塞当前的线程）
* 很难使用较小的并发来组件大型的并发

## Task
Task类解决上述问题，Task是一个相对高级的抽象：它代表了一个并发操作，该操作可由Thread支持，也可不由它支持
Task是可组合的，可使用Continuation把它们串成链
Task可使用线程池减少启动延迟

### Task.Run
Tak默认使用线程池，也就是后台线程，当主线程结束时，创建的所有tasks都会结束

### Task.Wait
调用Task.Wait方法会进行阻塞直到操作完成，相当于调用thread.Join方法

### Task<TResult>
```c#
 var task = Task.Run(() => {
                Console.WriteLine("Foo");
                return 3;
            });
            int result = task.Result;
            Console.WriteLine(result);
```

### Task异常
如果Task里抛出了一个未处理的异常，该异常就会重新抛出给
* 调用了wait()的地方
* 访问了Task<TResult>属性的地方

```c#
            Task task = Task.Run(() => { throw null; });
            try
            {
                task.Wait();
            }
            catch (AggregateException aex)
            {
                if(aex.InnerException is NullReferenceException)
                {
                    Console.WriteLine("Null");
                }
                else
                {
                    throw;
                }
            }
```
CLR会将异常包裹在AggregateException里，以便在并行编程场景中发会很好的作用。

也可通过Task的IsFaulted和IsCanceled属性检测出Task是否发生了故障，如果两个属性都返回false,则没有错误发生。

## TaskCompletionSource
除了Task.Run创建Task，还可使用TaskCompletionSource创建Task,且不需要在操作时阻塞线程。  
TaskCompletionSource提供一个可手动执行的“从属”Task,指示操作何时结束或发生故障，对IO-Bound类工作比较理想。  

使用TaskCompletionSource实现Task.Run
```c#
        //相当于调用Task.Factory.StartNew
        //并使用TaskCreationOptions.LongRunning选项来创建非线程池的线程
        static Task<TResult> Run<TResult>(Func<TResult> function)
        {
            var tcs = new TaskCompletionSource<TResult>();
            new Thread(() => {
                try
                {
                    tcs.SetResult(function());
                }
                catch (Exception ex)
                {
                    tcs.SetException(ex);
                }
            }).Start();
            return tcs.Task;
        }
```

TaskCompletionSource创建Task,但并不占用线程。  
使用TaskCompletionSource实现Task.Delay
```c#
        public static void Main()
        {
            //5秒后，Continuation开始时才占用线程
            Delay(5000).GetAwaiter().OnCompleted(() => {
                Console.WriteLine(5);
            });

            //以上相当于
            Task.Delay(5000).GetAwaiter().OnCompleted(() => Console.WriteLine(5));
            Task.Delay(5000).ContinueWith(ant => Console.WriteLine(5));
            //Task.Delay相当于异步版本的Thread.Sleep
            Console.ReadKey();
        }
       static Task Delay(int milliseconds)
        {
            var tcs = new TaskCompletionSource<object>();
            var timer = new System.Timers.Timer(milliseconds) { AutoReset = false };
            timer.Elapsed += delegate { timer.Dispose(); tcs.SetResult(null); };
            timer.Start();
            return tcs.Task;
        }
```


## 异步编程
原则是将长时间运行的函数写成异步的。
Task非常适合异步编程，因为它们支持Continuation

## await
await不会阻塞线程示例：
```c#
            Func<int, Task<int>> func = async x => {
                Console.WriteLine("Starting...x={0}", x);
                await Task.Delay(x * 1000);
                Console.WriteLine("after await thread...={0}", Thread.CurrentThread.ManagedThreadId);
                Console.WriteLine("Finished...x={0}", x);
                return x * 2;
            };


            Console.WriteLine("Main thread...={0}", Thread.CurrentThread.ManagedThreadId);

            Task<int> first = func(2);
            Task<int> second = func(5);
            Console.WriteLine("First result: {0}", first.Result);
            Console.WriteLine("Second result: {0}", second.Result);
            Console.WriteLine("thread id...{0}", Thread.CurrentThread.ManagedThreadId);
```
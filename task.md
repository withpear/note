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
TaskCompletionSource创建Task,可以获得所有Task的好处，不需要在操作时阻塞线程


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
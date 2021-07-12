# operation
* 一个operation分为 CPU Bound， IO Bound。
    * CPU Bound: 当前线程执行的一串指令（instruction）
    * IO Bound: 当前线程请求的作业，比如内核作业，或另外一个线程的CPU Bound operation

# synchrony(sync) VS asynchrony(async)
* sync 是一种设计模式： 
    1. 当前线程请求IO Bound operation；
    2. 立即进入等待模式；
    3. 当operation完成后，其结果（可能为void）在当前线程继续处理。
    
* async 是一种设计模式：
    1. 当前线程请求IO Bound operation, 并附加一个 function（根据情况叫做continuation（类似于使用await语法糖）或callback（明确提供一个function）） 和完成后在哪个线程继续执行；
    2. 当前线程开始执行其它在当前线程队列中的operation；
    3. 当IO Bound operation完成后，function 就会在设置的线程上调用用来处理result。

# parallel(并行)
* parallel是一种设计模式，即当前线程向另外一个线程请求operation，这个operation对于当前线程来说是IO Bound operation。
* 如果说当前线程等待另外一个线程完成，那么parallel和sync两种设计模式同时出现；
* 如果说当前线程不等待另外一个线程完成，那么parallel和async两种设计模式同时出现。
* 当当前线程向很多线程同时发起请求时，那么parallel将会升级为multithreading parallel（多并行）
* 当多个线程同时读取或修改一个variable的时候，就需要synchronization primitive ，例如mutex,lock... 
* 当一个系统需要使用到synchronization primitive时，那么它就是 preemptive ，例如C# 的 Thread;反之是 non-preemptive，例如 Lua 的 coroutine，它其实是虚假的Thread运行在一个真的Thread上。

# OS VS Async
* 在程序中，有时候会通过例如File.Open(path)获得一个handle/resource，实际上是操作系统创建的kernel object ，它被操作系统所拥有。如果在代码中没有被明确摧毁，就算它超出scope，它也仍然存在，所以使用完毕记得摧毁。当程序退出时，该程序创建的所有没有被其它程序同时使用的Handle都会被自动摧毁

* kernel object用来记录操作的详细信息，只能被操作系统直接使用。操作系统会提供一些API使得程序可以操作它

* Lua中userdata和kernel object有异曲同工之妙

## OS如何完成 sync I/O operation？
1. 得到一个handle，表示一个文件
2. 调用Read(handle)，请求sync读取文件
3. 操作系统suspend thread，thread的状态从running变成suspended
4. CPU就会进行context switch，执行其它的scheduled runnable thread
5. 当硬盘的driver读取完文件后，它会通知OS，OS会把suspended thread变成scheduled runnable thread，然后即将被CPU所执行  
   Sleep有异曲同工之妙，也是一个sync operation

sync + 单线程：虽然没有context switch，但是没有responsive  
sync + 多线程：虽然有responsive，但需要众多的context switch

举例:  
使用sync + 单线程(主线程)：
```c#
int Main()
{
    while(true)
    {
        string name = ListenPort(); // sync  程序对外界没有反应
        string content = ReadFile(name); //sync 假设读取文件需要10分钟   程序对外界没有反应
        Log(content);
    }
}
```

使用sync + 多线程(可以实现waterfall设计模式)： 逻辑清晰和responsive ；但是它使用系统线程来实现这种模式，耗费大量系统资源
```c#
int Main()
{
    new Thread(()=>{
        while(true)
        {
            string name = ListenPort(); // sync 
            new Thread(()=>{
                string content = ReadFile(name); //sync 假设读取文件需要10分钟   
                Log(content);
            }).Start();
        }
    }).Start();
    
    ExitClicked(); // sync
    return 0; // 退出程序
}
```

## OS如何取消 sync I/O operation？
一般没有常规办法取消，极端办法是在另外一个线程调用CancelIO(thread)，这个thread是一个 kernel obejct，表示要取消的那个thread，但此办法很危险。

## OS如何完成 async I/O operation？
### 1. 原始方法
每个handle有两个状态，一个是激活状态，一个是未激活状态。
1. 得到一个handle1和一个handle2，表示2个文件，此时两个handle都未被激活
2. 调用ReadAsync(handle1)，请求async读取文件，然后该方法会马上返回
3. 调用ReadAsync(handle2)，请求async读取文件，然后该方法会马上返回
4. 调用WaitAny(handle1,handle2)，此方法是sync operation，操作系统会suspend当前thread，当前thread的状态从running变成suspended
5. 当任意handle1或handle2操作完成后，操作系统会激活此thread

signal(async + 单线程)： 既responsive，又没有context switch  ；但是可读性很差，很难架构
```c#
int Main()
{
    List<Handle> handles = new List<Handle>();
    var handle1 = ListenExitClieckedAsync();
    handles.Add(handle1);
    var handle2 = ListenPortAsync();
    handles.Add(handle2);

    while(true)
    {
        int n = WaitAny(handles);
        if (n == 0)
        {
            return 0;
        }
        else if(n == 1)
        {
            string name = GetResult(handles[n]);
            var handle = ReadFileAsync(name);
            handles.Add(handle);
        }
        else
        {
            string content = GetResult(handles[n]);
            CloseHandle(handles[n]);
            handles.Remove(n);
            Log(content);
        }
    }
}
```

### 2. APC(async procedure call)
每个线程都有一个 APC Queue，用来存储delegate
APC(async + 单线程) : 可读性比signal(async + 单线程)好一点，但是会造成callback hell，而且收到结果的线程和请求IO的线程是一个线程（不能合理利用多核CPU的优势进行多并发，如果外界请求文件名过多，Log过多，然后APC Queue就会积累来不及处理，若使用多并发可解决这种问题）
```c#
int Main()
{
    ListenExitClickedAPCAsync(()=>{
        Environment.Exit();
    });
    ListenPortAPCAsync((name)=>{
        ReadFileAPCAsync(name,(content)=>{
            Log(content);
        });
    });

    while(true)
    {
        var apc = ReadAPC(); // WaitForSingleObjectEx 
        apc();
    }
}
```

### 3. I/O completion routine
每个程序在创始之初，系统都会给它分配一个线程池，所以线程不需要明确创建，可以直接向线程池请求。
这个线程池它有一个 IO Completion Port，它也类似于 APC Queue，只是每个线程有一个APC Queue，而每个程序只有一个IO Completion Port
```c#
int Main()
{
    ListenExitClickedPortAsync(()=>{
        Environment.Exit();
    });
    ListenPortPortAsync((name)=>{
        ReadFilePortAsync(name,(content)=>{
            Log(content);
        });
    });

    while(true)
    {
        WaitIOCompletionPort();
    }
}
```


# Task-based Asynchronous Pattern Model(TAP Model)
这个模型的载体是一个返回awaitable的function，这个function分为两类：手动，自动

* 手动(一般来说是向操作系统请求IO Operation)
    1. 自己构建awaitable,或者使用现成的TaskCompletionSource + TaskCompletionSource.Task
    2. 若使用自己构建的awaitable，它的逻辑大概为：
        ```c#
        public class MyAwaiter<T>: INotifyCompletion
        {
            public Action Continuation;
            public T Result;
            public bool Completed;
            public bool IsCompleted { get => Completed; }
            public void OnCompleted(Action continuation)
            {
                if (!Completed)
                {
                    Continuation = continuation;
                }
                else
                {
                    continuation();
                }
            }

            public T GetResult()
            {
                return Result;
            }
        }
        public class MyAwaitable<T>
        { 
            public List<MyAwaiter<T>> Awaiters = new List<MyAwaiter<T>>();
            public bool Completed;
            public T Result;
            public MyAwaiter<T> GetAwaiter()
            {
                var awaiter = new MyAwaiter<T>();
                awaiter.Completed = Completed;
                awaiter.Result = Result;
                Awaiters.Add(awaiter);
                return awaiter;
            }
        }
        public class MySource<T>
        {
            public MyAwaitable<T> Awaitatble{ get; private set;}
            public MySource()
            {
                Awaitabale = new MyAwaitable<T>();
            }
            public void SetResult(T value)
            {
                Awaitable.Completed = true;
                Awaitable.Result = value;
                var count = Awaitable.Awaiters.Count;
                for (int i = 0; i < count; i++)
                {
                    Awaitable.Awaiters[i].Result = value;
                    Awaitable.Awaiters[i].Completed = true;
                    Awaitable.Awaiters[i].Continuation();
                }
            }
        }
        // 使用自己构建的awaitable
        public MyAwaitable<int> PrintDocumentAsync(string content)
        {
            var source =new MySource<int>();
            unsafe
            {
                print_document(content, (result)=>{
                    source.SetResult(result);
                });
            }
            return source.Awaitable;
        }
        ```
    3. 若使用现成的TaskCompletionSource + TaskCompletionSource.Task，它的逻辑大概为：
        ```c#
        public Task<int> PrintDocumentAsync(string content)
        {
            var tcs = new TaskCompletionSource<int>();
            unsafe
            {
                print_document(content, (result)=>{
                    tcs.SetResult(result);
                });
            }
            return tcs.Task;
        }
        ```
    4. 当awaitable.GetAwaiter()被调用时，它会构建一个新的awaiter
* 自动(一般来说是包含了其它的一个或多个自动和手动)
    1. 每个自动function，系统都会创建相对应的coroutine，这个coroutine内部会包含一个TaskCompletionSource
    2. 假设一个自动function里await了另外两个function（1号和2号），最后return了一个值，那么这个coroutine里会分为三个小步骤，也就是可以resume三次。当调用这个function的时候，它会实例化这个coroutine,并且resume它，这个过程非常快不会等待，然后返回TaskCompletionSource.Task。 当1号function完成后，它会resume(第二次)这个coroutine，并且调用2号function；当2号function完成后，它会resume(第三次)这个coroutine,这时会得到结果，并且把结果传递给外界(TaskCompletionSource.SetResult())，以此类推。
    ```c#
        // 自动function
        public static async Task<int> Foo()
        {
            var awaitable = PrintDocumentAsync("apsldk");
            Console.WriteLine("请求完毕");
            var len1 = await awaitable;
            var len2 = await awaitable;
            Console.WriteLine(len1);
            Console.WriteLine(len2);
            return len1 + len2;
        }   

        // 自动function Foo() 内部会被转换为
        public static Task<int> Foo_()
        {
            var coroutine = new Coroutine();
            coroutine.Resume();
            return coroutine.taskCompletionSource.Task;
        }
        public class Coroutine
        {
            public TaskCompletionSource<int> taskCompletionSource = new TaskCompletionSource<int>();
            private int state = 0;
            private int result;
            private Task<int> awaitable;
            public void Resume()
            {
                if (state == 0)
                {
                    var tcs =new TaskCompletionSource<int>();
                    PrintDocument("apsldk", (r) => {
                        tcs.SetResult(r);
                    });
                    awaitable = tcs.Task;
                    var awaiter = awaitable.GetAwaiter();
                    awaiter.OnCompleted(()=> {
                        result = awaiter.GetResult();
                        state++;
                        Resume();
                    });
                }
                else if (state == 1)
                {
                    var awaiter = awaitable.GetAwaiter();
                    awaiter.OnCompleted(() => {
                        result += awaiter.GetResult();
                        state++;
                        Resume();
                    });
                }
                else if(state == 2)
                {
                    taskCompletionSource.SetResult(result);
                }
            }
        }
        static void PrintDocument(string content, Action<int> action)
        {
            new Thread(() => {
                Thread.Sleep(2000);
                action(content.Length);
            }).Start();
        }
    ```

## TAP相对于callback的优势
TAP是对callback的一种封装
* callback要在同一个地方写明请求IO代码（PrintDocument(...)）和处理IO代码,然而TAP请求IO的代码和处理IO的代码可以完全分开，它也可以被系统不同地方处理同一个操作，类似于一个event
```c#
PrintDocument((len)=>{
    Console.WriteLine(len);
});
```
```c#
var task = PrintDocumentAsync();
// 过了好久... 其它逻辑...
F10(task); // F10新开一个线程，await task，然后播放音乐
var len = await task;
Talk(); 
```
* callback会造成calback hell,然而TAP不会，可以使用自动function
```c#
PrintDocument((len)=>{
    Console.WriteLine(len);
    PlayMusic((name)=>{
        Console.WriteLine(name);
    });
});
```
```c#
var len = await PrintDocumentAsync();
Console.WriteLine(len);
var name = await PlayMusicAsync();
Console.WriteLine(name);
```
* 关于错误和异常处理
callback没办法抛出异常，只能通过参数传递错误
```c#
// TAP
try
{
    var len = await PrintDocumentAsync(); // 如果打印机坏掉，会抛出异常
    Console.WriteLine(len);
    var name = await PlayMusicAsync(); // 如果扬声器坏掉，会抛出异常
    Console.WriteLine(name);
}
catch(Exception e)
{
    DisplayMessage(e.message);
}
```
```c#
// callback
PrintDocument((len,e)=>{
    if(e)
    {
        DisplayMessage(e.message);
        return;
    }
    Console.WriteLine(len);
    PlayMusic((name,e)=>{
        if(e)
        {
            DisplayMessage(e.message);
            return;
        }
        Console.WriteLine(name);
    });
});
```
* TAP可以把操作封装在一个awaitble里，方便记录和观察；callback一旦调用后就石沉大海

* awaitable表示一个操作，每一个awaiter和一个等待者对接。一个awaitable可能有多个awaiter

# synchronization在Unity中的逻辑
```c# 
Capture()
{
    if(Thread.Current == UIThread)
    {
        this.kind = "UI" ;
    }
    else
    {
        this.kind = "pool";
    }
}
Post(Action action)
{
    if (this.kind == "UI")
    {
        UIThread.APCQueue.Add(action);
    }
    else
    {
        ThreadPool.Add(action);
    }
}
```
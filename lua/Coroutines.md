# iterator

* 在C#中，一个 IEnumerable 表示一个数据源，比如说是一个数据库的表格，或者说是一个array。一个 IEnumerator表示一次迭代的状态，比如说它保存了当前读到的表格行数，或者说是一个array当前的index。举个例子：有一个array(它是一个IEnumerable),它在线程1和线程2中同时被迭代，这时线程1中的IEumerator保存了当前的index (2)，在线程2中的IEumerator保存了当前的index (5)。

* 在Lua中for ... in ，in的后面是一个 f1() ，它返回一个 f2,state(不重要),control,closing(不重要)

  f2是一个iterator(和IEumerator一个东西)，如果它产生的值来自于某个数据源(IEnumerable)，那么它就需要把这个数据源当作一个upvalue

  ```lua
  function f1()
    local arr = {1,2,3,4}
    local f2 = function()
      return ...
    end
    return f2,state,control,closing
  end
  ```



# Coroutines

* 一个coroutine可以由coroutine.create + f 创建，返回值co的类型为thread，此时coroutine并未开始，co处于挂起状态

* 当第一次调用coroutine.resume(co,a,b) 时，这时f(a,b)在coroutine里运行，直到遇到coroutine.yield或return

* 当f执行完毕时( return x,y ) ，coroutine.resume会返回true,x,y， 这个coroutine会结束

* 当f内发生错误(error())时，coroutine.resume会返回true,error， 这个coroutine会结束

* 当f内遇到coroutine.yield(x1,y1)时，这时f的执行会挂起，yield此时还未return, 它只是向外部传递了x1,yx，外部的coroutine.resume会返回 true,x1,y1

  当下一次coroutine.resume(co,a1,b1)时，挂起的yield会返回a1,b1

* coroutine.status有三个身份（大哥，自己，小弟），四个状态（normal, suspended, running, dead）。大哥看小弟，小弟只有两个状态（suspended，dead），小弟看大哥，大哥只有一个状态（normal）,自己看自己，只有一个状态（running）
  小弟刚刚被创建时，状态为suspended

  小弟里没有yield时，只有一个 ping pong(表示一个resume)，然后小弟就会dead

  小弟里有一个yield时，那么它有两个 ping pong，然后小弟就会dead
  
  有些小弟没有明确的return，但是它表示return nil，也就是最后一次pong 是一个nil

*  在Lua可以实现和 Obeservable operator一样的结构，参见书里的filter
 
* Lua中的coroutine可以变成一个iterator


* 当前coroutine可以把主导权交给外部，然后自己yield
```lua
local unity = require("unity")
local function await(f, ...)
    f(coroutine.running(), ...)
    coroutine.yield()
end
local function foo()
    local a = 10
    await(unity.TimeoutAsync, 2)
    print(a)
    await(unity.TimeoutAsync, 5)
    print(a * 2)
end
return coroutine.create(foo)
```
外部等到5秒钟之后调用resume，把主导权返回给coroutine

以前的实现方式
```lua
function f1()
  local a = 10
  unity.Timeout(5, function()
      print(a)
      unity.Timeout(10, function()
        print(a+a)
      end)
  end)
end
```











* To Rebecca 

  * asymmetric coroutines : 除了yield，用户还可以使用resume

    对应的，symmetric coroutine，用户只能使用yield, resume用户不可见，一般来说由库或框架操作resume（框架一般来说有一个大循环）。例子：unity里的coroutine

    由此可见，symmetric coroutine也是由asymmetric coroutine实现的

  * restricted coroutines: 只能在coroutine 的 main function中调用 yield ，将coroutine挂起

    unrestricted coroutines: 非限制的coroutine,可以在coroutine的main function中调用其它包含yield的function来挂起coroutine

  * semi-coroutines: 根据语境，可能是指asymmetric coroutines，也可能是指restricted coroutines

  * Lua提供的coroutine 是 asymmetric coroutines 和 unrestricted coroutines





  * IObservable<T>.Subscribe(IObserver<T>) 
    * IObservable是 producer, IObserver是 consumer
    * 在Reactive中，Subject同时充当了Observer和Observable的角色 
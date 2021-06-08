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






* Rebecca's note: 

  * asymmetric coroutines : 需要一个函数（yield）来挂起一个coroutine，需要另一个函数（resume）来唤醒这个被挂起的coroutine

  * asymmetric coroutines有时被称为semi-coroutines ，但semi-coroutines也可表示restricted coroutines
  
    * asymmetric coroutines： 非限制的coroutine,可以在coroutine的main function中调用其它包含yield的function来挂起coroutine

    * restricted coroutines: 只能在coroutine 的 main function中调用 yield ，将coroutine挂起


  * IObservable<T>.Subscribe(IObserver<T>) 
    * IObservable是 producer, IObserver是 consumer
    * 在Reactive中，Subject同时充当了Observer和Observable的角色 
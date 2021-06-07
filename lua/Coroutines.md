# Coroutines

* 一个coroutine可以由coroutine.create + f 创建，返回值co的类型为thread，此时coroutine并未开始，co处于挂起状态

* 当第一次调用coroutine.resume(co,a,b) 时，这时f(a,b)在coroutine里运行，直到遇到coroutine.yield或return

* 当f执行完毕时( return x,y ) ，coroutine.resume会返回true,x,y， 这个coroutine会结束

* 当f内发生错误(error())时，coroutine.resume会返回true,error， 这个coroutine会结束

* 当f内遇到coroutine.yield(x1,y1)时，这时f的执行会挂起，yield此时还未return, 它只是向外部传递了x1,yx，外部的coroutine.resume会返回 true,x1,y1

  当下一次coroutine.resume(co,a1,b1)时，挂起的yield会返回a1,b1


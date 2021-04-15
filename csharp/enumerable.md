# 枚举器 enumerator
* 枚举器是一个只读的，作用于一序列值的，只能向前的游标。
* 枚举器是一个实现了下列任意一个接口的对象：
    * System.Collection.IEnumrator
    * System.Collection.Generic.IEnumerator<T>
* foreach语句会迭代可枚举的对象。可枚举的对象是一序列值的逻辑表示，它本身不是游标，是一个可以基于本身产生游标的对象。

## 可枚举对象 enumerable object
一个可枚举对象可以是下列任意一个：
* 实现了IEnumerable或IEnumerable<T>的对象
* 有一个名为GetEnumerator的方法，并且该方法返回一个枚举器（enumeator）

IEnumerator和IEnumerable是定义在System.Collections命名空间下的；  
IEnumerator<T>和IEnumerable<T>是定义在System.Collections.Generic命名空间下的。

## 迭代器 Iterator
foreach语句是枚举器（enumerator）的消费者，而迭代器（iterator）是枚举器的生产者。

```c#
  class Program
    {
        static void Main(string[] args)
        {
            //foreach (var fib in Fibs(6))
            //{
            //    Console.Write(fib + " ");
            //}

            using (var enumerator = Fibs(6).GetEnumerator())
            {
                while (enumerator.MoveNext())
                {
                    Console.Write(enumerator.Current + " ");
                }
            }
        }

        static IEnumerable<int> Fibs(int fibCount)
        {
            for (int i = 0, prefib = 1, curfib = 1; i < fibCount; i++)
            {
                yield return prefib;
                int newfib = prefib + curfib;
                prefib = curfib;
                curfib = newfib;
            }
            Console.Write("Done");
        }
    }
```
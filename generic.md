# 泛型

## Variance
variance只能出现在接口和委托里。

* Covariance 协变：当值作为返回值 output
```c#
public interface IEnumerable<out T> 
```
示例： IEnumerable<string>可以转换为IEnumerable<object> ，IEnumerable<T> T是仅作为返回类型。
```c#
IEnumerable<string> strings = new List<string> {"a", "b", "c"};
IEnumerable<object> objects = strings;//OK
```

* Contravariance 逆变： 当值作为输入input
```c#
public delegate void Action<in T>
```
示例： Action<object>可以转换为Action<string>  ，Action<T> T仅作为输入类型。
```c#
Action<object> objectAction = obj => Console.WriteLine(obj);
Action<string> stringAction = objectAction;
stringAction("hi");//OK
```

* Invariance 不变： 当值既是输入又是输出
```c#
public interface IList<T> 
```
示例： IList<string>不可以转换为IList<object>  ，Action<T> T既是输入又是输出，这样做不安全。
```c#
IList<string> strings = new List<string> {"a", "b", "c"};
IList<object> objects = strings; //此处会编译报错
objects.Add(new object());
string element = strings[3];//出错
```

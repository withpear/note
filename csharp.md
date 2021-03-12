# CSharp

## 安装
1. 安装.Net Core SDK
2. Powershell输入dotnet，查看是否安装成功
3. 选择安装IDE（Visual Studio, Visual Studio Code...）
4. Visual Studio Code安装c#插件
5. Powershell进入指定目录，输入dotnet new [Template] --name [createdName]
6. 输入 code .  ，使用VS Code打开该项目
7. 输入 dotnet run 运行项目 （dotnet run 包含了 dotnet restore , dotnet build）

## 关键字
如果非得用关键字当标识符，则在它前面加一个@


## 可空（值）类型 Nullable Types
要在值类型里表示null值，必须使用一种特殊的构造：可空（值）类型   
表示：  值类型?  
例如 ： int? i = null;  

### Nullable<T> Struct
T?表示的可空类型会被翻译成System.Nullable<T>,是一种轻量级不可变的结构。
```c#
int? i = null;
Console.WriteLine(i == null); //True
```
会被翻译成：
```c#
Nullable<int> i = new Nullable<int>();
Console.WriteLine(!i.HasValue); //True
```


## 扩展方法
扩展方法运行使用新的方法来扩展现有的类型，而无需修改原有类型的定义。  
扩展方法是静态类的一个静态方法，在静态方法里的第一个参数使用this修饰符，第一个参数的类型就是要被扩展的类型。
```c#
 public static class StringHelper
    {
        public static bool IsCapitalized(this string s)
        {
            if (string.IsNullOrEmpty(s))
            {
                return false;
            }
            return char.IsUpper(s[0]);
        }
    }
 Console.WriteLine("Path".IsCapitalized());
```

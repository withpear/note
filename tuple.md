
# Tuple
使用Tuple的主要目的是从方法安全的返回多个值，而无需使用out参数

```c#
        static void Main(string[] args)
        {
            // Tuple
            var bob = ( "Bob", 30 );
            Console.WriteLine(bob.Item1);
            Console.WriteLine(bob.Item2);
            // Tuple是值类型，元素是可读写的
            var joe = bob;
            joe.Item1 = "Joe";
            Console.WriteLine(bob);
            Console.WriteLine(joe);
            //可明确指定Tuple类型
            //(string, int) bob = ("Bob", 23);

            // Tuple作为返回类型
            (string, int) person = GetPerson();
            Console.WriteLine(person.Item1);
            Console.WriteLine(person.Item2);

            //Tupel与泛型
            Task<(string, int)> a;
            Dictionary<(string, int), Uri> b;
            IEnumerable<(int ID, string Name)> c;

            var tuple = (Name :"Bob", Age : 10);

            //Tuple类型兼容
            (string Name, int Age, char Sex) bob1 = ("Bob", 23, '男');
            (string Age, int Sex, char name) bob2 = bob1;

            //Tuple Deconstructing 模式
            var rebecca = ("Rebecca", 25);
            //string name = rebecca.Item1;
            //int age = rebecca.Item2;

            (string name, int age) = rebecca;// Deconstructing 模式
            Console.WriteLine(name);
            Console.WriteLine(age);

            //相等性比较
            var t1 = ("one", 1);
            var t2 = ("one", 1);
            Console.WriteLine(t1.Equals(t2));//True
        }

        static (string, int) GetPerson() => ("Bob", 23);
```

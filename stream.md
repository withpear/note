# 总结
* 基础流： 核心为Stream基类，定义了所有流所应具有的行为。 基础流的底层都对应了一种后备存储（backing store）。 
FileStream对应的后备存储为文件，MemoryStream对应的是内存，NetworkStream对应的网络源。

* 装饰器流
包含了一个Stream流基类的引用，同时继承自Stream基类。没有backing store,可应用于所有流类型。  
BufferedStream  
DeflatStream  
GZipStream  
CryptoStream  

* 包装器类  
包含了一个流的引用，提供对流进行操作的简便方法，相当于一个包装器（wrapper）。
1. StreamReader和 StreamWriter  
StreamReader用于将流中的数据读取为字符，StreamWrite将字符写入流中。  
StreamReader和StreamWriter存在意义：  
涉及文本文件就会遇到编码方式问题。编码方式定义了字节如何转换。如果文件创建时使用一种编码方式如GB2312编码，读取时又采用了另一种编码方式比如UTF8编码，就不能转换成正确的字符了。使用StreamReader和StreamWriter可指定编码方式。  
```c#
//StreamReader
 using (var stream = File.OpenRead(pathSource))
    {
        StreamReader reader = new StreamReader(stream);//默认编码方式指定为UTF-8
        // 相当于  StreamReader reader = new StreamReader(stream, Encoding.UTF8)
        var str=reader.ReadToEnd();
        Console.WriteLine(str);
    }
//StreamWriter
using (StreamWriter writer = new StreamWriter(pathNew, true, Encoding.UTF8))
{
    writer.Write(str);
}
```
2. BinaryReader和 BinaryWriter  
适用于向流中以二进制方式写入/读取基元类型。  
```c#
  public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Price { get; set; }
    }
    public static void ReadClassUsingBinaryReader()
    {
        string path = @"..\..\..\product.txt";
        Product product = new Product() { Id = 1, Name = "CocaCola", Price = 3.5f };
        using (var stream = new FileStream(path,FileMode.OpenOrCreate,FileAccess.Write))
        {
            BinaryWriter writer = new BinaryWriter(stream,Encoding.ASCII);
            writer.Write(product.Id);
            writer.Write(product.Name);
            writer.Write(product.Price);
        }

        Product product1 = new Product();
        using (var stream = new FileStream(path, FileMode.Open, FileAccess.Read))
        {
            BinaryReader reader = new BinaryReader(stream);
            product1.Id = reader.ReadInt32();
            product1.Name = reader.ReadString();
            product1.Price = reader.ReadDouble();
        }

        Console.WriteLine(product1.Id);
        Console.WriteLine(product1.Name);
        Console.WriteLine(product1.Price);
    }
```
* 帮助类  
File Directory      
FileInfo DirectoryInfo   
# stream
stream是一个用于传输数据的对象，数据可向两个方向传输，则stream可分为读写流和写入流。  
外部源可以是文件流，内存流，网络流或任意数据源（例代码中的一个变量）。

## FileStream
一般使用StreamReader和StreamWriter替代FileStream。   
因为FileStream类操作的是字节和字节数组，而Steam类操作的是字符数据。字符数据易于使用，但某些操作例如随机文件访问（访问文件中间某点的数据），就必须由FileStream对象执行。   
FileStream类只能处理原始字节（raw byte），这使FileStream类可用于任何数据文件，不仅是文本文件还可以读取如图像声音文件。

```c#
FileStream fileStream = new FileStream(fileName, FileMode.Open);//FileAccess默认为FileAccess.Write
```
使用File和FileInfo更易于创建FileStream对象。
```c#
FileStream fileStream = File.OpenRead(fileName);
```
```c#
FileInfo fileInfo = new FileInfo(fileName);
FileStream fileStream = fileInfo.OpenRead()
```

### Seek()
文件指针，指向文件中进行下一次读写操作的位置。   
将文件指针移到文件的第8个字节处，起始位置是文件的第一个字节。
```c#
fileStream.Seek(8, SeekOrigin.Begin);
```
将文件指针从当前位置向前移动2个字节。
```c#
fileStream.Seek(2, SeekOrigin.Current);
```
查找文件中倒数第5个字节。
```c#
fileStream.Seek(-5, SeekOrigin.End);
```

### 读写数据
```c#
public static void ReadAndWriteUsingFileStream()
{
    string pathSource = @"..\..\..\source.txt";
    string pathNew = @"..\..\..\newfile.txt";
    try
    {
        byte[] bytes = new byte[1024];
        using (var stream = new FileStream(pathSource, FileMode.Open, FileAccess.Read))
        {
            int bytesRead;
            do
            {
                bytesRead = stream.Read(bytes, 0, bytes.Length);
            } while (bytesRead > 0);
        }

        using (var stream = new FileStream(pathNew, FileMode.OpenOrCreate, FileAccess.ReadWrite))
        {
            stream.Write(bytes, 0, bytes.Length);
        }
    }
    catch (IOException ioEx)
    {
        Console.WriteLine(ioEx.Message);
    }
}
```


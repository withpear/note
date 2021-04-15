# 文件
## FileSystemInfo： 抽象类。任何文件系统对象的基类
```c#
        public static void ThroughFilesAndDirs()
        {
            string path = @"C:\";
            foreach (var entry in Directory.EnumerateDirectories(path))
            {
                DisplayFileSystemInfoAttributes(new DirectoryInfo(entry));
            }

            foreach (var entry in Directory.EnumerateFiles(path))
            {
                DisplayFileSystemInfoAttributes(new FileInfo(entry));
            }
        }

        static void DisplayFileSystemInfoAttributes(FileSystemInfo fsi)
        {
            string entryType = "File";
            if((fsi.Attributes & FileAttributes.Directory) == FileAttributes.Directory)
            {
                entryType = "Directory";
            }
            Console.WriteLine("{0} entry {1} was created on {2:D}", entryType, fsi.FullName, fsi.CreationTime);
        }
```
##  FileInfo和File:  文件系统上的文件
### File: 静态类，不能被实例化。如果只对文件执行一个操作使用该类更有效。  
###  FileInfo: 需要实例化，若需在文件上执行几种操作，则实例化FileInfo对象并使用其方法更有效。
```c#
            //检查data.txt文件是否存在
            FileInfo afile = new FileInfo("data.txt");
            if (afile.Exists)
            {
                Console.WriteLine("File exists");
            }
            //同上，检查data.txt文件是否存在
            if (File.Exists("data.txt"))
            {
                Console.WriteLine("File exists");
            }
```

```c#
        //使用FileInfo访问文件信息
        static void Main(string[] args)
        {
            FileInfomation(@"..\..\..\Program.cs");
        }
        static void FileInfomation(string filename)
        {
            var file = new FileInfo(filename);
            Console.WriteLine($"Name: {file.Name}");
            Console.WriteLine($"Directory: {file.Directory}");
            Console.WriteLine($"Read Only : {file.IsReadOnly}");
            Console.WriteLine($"Extension : {file.Extension}");
            Console.WriteLine($"Length : {file.Length}");
            Console.WriteLine($"CreationTime : {file.CreationTime:F}");
            Console.WriteLine($"LastAccessTime : {file.LastAccessTime:F}");
            Console.WriteLine($"Attributes : {file.Attributes}");
        }
        // Name: Program.cs
        // Directory: D:\practices\Stream
        // Read Only : False
        // Extension : .cs
        // Length : 4061
        // CreationTime : 2021年2月26日 8:30:23
        // LastAccessTime : 2021年3月1日 16:19:23
        // Attributes : Archive
```

##  DirectoryInfo和Directory: 文件系统上的文件夹
区别同上。补充：使用静态类File和Directory检索文件多个信息时，访问速度将变慢，因为每个访问都意味着检查，以确定用户是否允许得到这个信息。而使用FileInfo和DirectoryInfo时只有调用构造函数时才进行检查。  
```c#
        static void EnumerateFiles()
        {
            string archiveDir = "archive";
            var files = from retrievedFile in Directory.EnumerateFiles(archiveDir, "*.txt", SearchOption.AllDirectories)
                        from line in File.ReadLines(retrievedFile) //声明性查询语句
                        where line.Contains("Example")
                        select new
                        {
                            File = retrievedFile,
                            Line = line
                        };

            foreach (var f in files)
            {
                Console.WriteLine("{0} constains {1}", f.File, f.Line);
            }
            Console.WriteLine("{0} lines found.", files.Count().ToString());
        }
```

**路径中/与\的区别：**  
* Windows下路径中`/`，`\`都可以使用，Linux下路径只可以使用`/`。  
* 由于在ASCII中字符`\`是转义字符，所以要表示`\`需要多加一个`\`，而`/`不需要多加。在路径前添加`@`，可使\变成`\\`。  
* 浏览器地址栏中的网址使用`/`作为路径分隔符，Windows文件浏览器中使用反斜杠`\`作为路径分隔符。  
* 出现在html,url属性中的路径必须使用斜杠`/`。



# Path
基于Windows和Unix系统，处理不同平台路径需求。  
```c#
            // 公共字段，得到特定于平台的用于区分硬盘，文件夹，文件，以及分隔多个路径
            Console.WriteLine(Path.VolumeSeparatorChar); // Windows中该字符是  :
            Console.WriteLine(Path.DirectorySeparatorChar);// Windows中该字符是   \
            Console.WriteLine(Path.AltDirectorySeparatorChar);// Windows中该字符是   /
            Console.WriteLine(Path.PathSeparator);// Windows中该字符是   ;

            // 合成路径，自动处理路径分隔符
            string[] paths = { @"d:\archives", "2021", "media", "images" };
            string fullPath = Path.Combine(paths);
            Console.WriteLine(fullPath);//d:\archives\2021\media\images
```

# Environment

```c#
            var env = Environment.GetEnvironmentVariables();
            var os = Convert.ToString(env["OS"]);
            var dr = Convert.ToString(env["SystemDrive"]);

            Console.WriteLine(os); // Windows_NT
            Console.WriteLine(dr); // C:
            
            Console.WriteLine(Environment.SpecialFolder.MyDocuments);// MyDocuments
            Console.WriteLine(Environment.GetEnvironmentVariable("HOMEPATH"));// \Users\Pei Li
```
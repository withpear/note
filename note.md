# 2021.2.25
## KeyValuePair<TKey,TValue>  
KeyValuePair 是一个结构体（struct）,只包含一个Key,Value键值对；  
Dictionary可看作是KeyValuePair的集合，可以包含多个Key,Value键值对。
```c#
    Dictionary<string, string> openWith = new Dictionary<string, string>();
    openWith.Add("txt", "notepad.exe");
    openWith.Add("bmp", "paint.exe");
    foreach (KeyValuePair<string, string> kvp in openWith)
    {
        Debug.Log($"{kvp.Key}:{kvp.Value}");
    }
```
## IEnumerable 

## IEnumerator

## yield

## Stream
* MemoryStream
* FileStream 
* BufferedStream 
## Encoding.UTF8
# Unity Addressables

## Content update workflow 内容更新工作流
```c#
while(New unity version)
{
    while(New logic)
    {
        while(New content)
        {
            if (n == 1)
            {
                Click `Addressables Groups Windows/Build/New Build/New Build/Default Build Script`
            }
            Click `Addressables Groups Windows/Tools/Check for Content Update Restrictions`
            Click `Addressables Groups Windows/Build/Update a Previous Build`(This will update addressables_content_state.bin)
        }
        Click `File/Build Settings/Build`
    }
}

```
CDN: content delivery network  
让每一个网站都实现服务器自由。让离你最近的服务器给你发送数据，并且有缓存机制，能让多次相同的请求数据直接从缓存服务器获取，而无需请求源服务器。  

Addressables为游戏提供了内容更新工作流用来动态的从CDN下载内容。app被构建和部署后，当它运行时，它就会连接CND发现并下载其它内容。  
这和使用平台提供补丁系统（switch,steam）的游戏不同，使用这些系统的游戏每次build都应该是全新的内容版本，完全绕过更新流。这种例子就可以完全忽略addressables_content_state.bin 文件。因为它不需要热更新。  

### Project structure
Unity建议将游戏内容分为两类：  
* Cannot Change Post Release 不会更新的静态内容  
* Can Change Post Release  希望更新的动态内容  

在使用这两类的结构中，静态内容会附加到app中（或者下载app后很快安装）,它们在很少但很大的bundles中。动态内容在网上，最好在较小的bundle包中以便在更新时所需的数据最小化。Addressable Assets System的目标就是使这个结构易于使用并修改，且无需修改脚本。  

但是，当你不想再重新发布整个app时，Addressable Assets System 也可以修改静态内容。修改后的assets和依赖项将会在新的bundle中被复制，用来替代已经被发布的内容。与替换整个bundle包或重新构建游戏相比，这样做使得更新少得多。  
一旦构建完成，在下一次全新的构建之前，不要将group的状态从`Cannot Change Post Release`变为`Can Change Post Release`。如果在全部内容构建后，内容更新前修改了group状态，Addressables 将无法生成更新所需的正确修改。

### How it works 
Addressables使用内容目录将address映射到每个asset中，内容目录指明了在哪里和如何加载asset。  
为了app修改映射，那么原始app必须知道这个内容目录的线上副本，在`AddressableAssetSettings `中勾选`Build Remote Catalog`构建远程目录，这能确保这个目录副本从指定的路径构建和加载。一旦app发布，那么这个加载路径就不能改变。内容更新进程会创建一个新版本的目录（和原来名字相同）来重写原来在指定加载路径加载的目录。  
构建一个app将会生成一个独一无二的app内容版本字符串，用来标识每个app应该加载什么目录。给定的服务器可以包含多个版本的目录且没有冲突。我们将所需要的数据存储在addressables_content_state.bin文件中，这个文件包含了版本字符串，和包含在标记为StaticContent的group的asset的hash信息。  
addressables_content_state.bin文件包含Addressables系统中每个静态group的hash和依赖信息。

## 内存管理
Addressables Asset内存管理最主要方法就是正确管理加载和卸载的调用，怎么做取决于asset类型和加载方式。
1. Asset加载  
使用`Addressables.LoadAssetAsync` (单个asset)或 `Addressables.LoadAssetsAsync` (多个assets)来加载Asset，这种方式会将asset加载到内存但不实例化它。每次调用加载执行时，它都会为要加载的asset添加一个引用计数。    
例如调用3次`Addressables.LoadAssetAsync`方法加载同一个asset时，返回的`AsyncOperationHandle`结果实例指向相同的底层操作。该asset的引用计数也为3。  
如果加载成功，`AsyncOperationHandle`在`.Result`属性包含asset，可以使用unity实例化方法实例化它，不会增加该asset的引用计数。    
要卸载该asset，使用`Addressables.Release `方法来减少ref计数，当asset的引用计数为0时，该asset就会被卸载，并且减少任何它依赖的依赖项的引用计数。 
当asset引用计数为0时，asset在内存中卸载，所有通过它而实例化的物体也会消失。  
```c#
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
// 连续点击三次"LoadCube"按钮，场景出现3个cube
// 当点击"Release"一次时，场景3个cube依旧存在
// 点击第二次时,未报错（此时handle未被release,只是asset引用计数减1），场景3个cube依旧存在
// 点击第三次时，场景出现3个cube消失，asset引用计数为0，被从内存中卸载，handle被release
// 若再次点击"Release"按钮，报错"Exception: Attempting to use an invalid operation handle"
public class ReleaseController : MonoBehaviour
{
    private AsyncOperationHandle<GameObject> handle;
    private GameObject cube;
    private void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 100, 50), "LoadCube"))
        {
            LoadCube();
        }

        if (GUI.Button(new Rect(0, 80, 100, 50), "Instantiate"))
        {
            InstantiateCube();
        }

        if (GUI.Button(new Rect(0, 160, 100, 50), "Release"))
        {
            ReleaseByAsyncOperationHandle();
        }
    }

    void LoadCube()
    {
        // 每次调用Addressables.LoadAssetAsync返回的结果都赋给相同的handle
        handle = Addressables.LoadAssetAsync<GameObject>("redcube");
        handle.Completed += LoadDone;
    }

    private void LoadDone(AsyncOperationHandle<GameObject> obj)
    {
        handle = obj;
        cube = Instantiate(obj.Result, Random.insideUnitSphere * 3, Quaternion.identity);
    }

    void ReleaseByAsyncOperationHandle()
    {
        //减少引用计数，当引用计数为0时，asset被卸载
          Addressables.Release(handle);
        //  Addressables.Release(handle.Result);
    }

    void InstantiateCube()
    {
        //当asset被卸载后，实例化的物体会被清除
        Instantiate(cube, Random.insideUnitSphere * 3, Quaternion.identity);
    }

```
2. Scene加载  
使用`Addressables.LoadSceneAsync`加载场景，可使用该方法以Single模式加载场景，则会关闭其它打开的场景，或者以Additive模式加载场景。  
使用`Addressables.UnloadSceneAsync`卸载场景，或在Single模式下打开新场景。  
```c#
            //加载
            var handle=Addressables.LoadSceneAsync("main", UnityEngine.SceneManagement.LoadSceneMode.Single);      
            //卸载      
            Addressables.UnloadSceneAsync(handle);

```
3. GameObject实例化  
使用`Addressables.InstantiateAsync`加载和实例化GameObject Asset，这将实例化指定address的prefab。这会加载该asset和它的依赖项，并且引用计数加一。    
销毁GameObject使用`Addressables.ReleaseInstance`  
```c#
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

public class ReleaseGameObject : MonoBehaviour
{
    private AsyncOperationHandle<GameObject> handle;
    private GameObject cube;
    private void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 100, 50), "LoadCube"))
        {
            LoadCube();
        }

        if (GUI.Button(new Rect(0, 80, 100, 50), "Instantiate"))
        {
            InstantiateCube();
        }

        if (GUI.Button(new Rect(0, 160, 100, 50), "Release"))
        {
            ReleaseByAsyncOperationHandle();
        }
    }

    private void LoadDone(AsyncOperationHandle<GameObject> obj)
    {
        cube = obj.Result;
    }

    void LoadCube()
    {
        //此处handle与上面的Addressables.LoadAssetAsync不同，它是唯一的实例，每次返回的实例不同
        //若连续创建3个redcube，则使用handle只能销毁最后一个cube，再次调用ReleaseInstance(handle)会报错'Exception: Attempting to use an invalid operation handle'
        handle = Addressables.InstantiateAsync("redcube", Random.insideUnitSphere * 3, Quaternion.identity,null,true);//若设置为false,则释放实例时必须使用保留的AsyncOperationHandle
        handle.Completed += LoadDone;
    }
    void ReleaseByAsyncOperationHandle()
    {
        // 若 Addressables.InstantiateAsync()中trackHandle为false，则只能使用 Addressables.ReleaseInstance(handle)销毁物体，使用Addressables.ReleaseInstance(实例)无法销毁物体
        
        // 若 Addressables.InstantiateAsync()中trackHandle为true，则可使用 Addressables.ReleaseInstance(实例)销毁物体，如下
          Addressables.ReleaseInstance(handle.Result);
          //或者
          //Addressables.ReleaseInstance(cube);
    }

    void InstantiateCube()
    {
        Instantiate(cube, Random.insideUnitSphere * 3, Quaternion.identity);
    }
}

```  
4. Data loading   
数据加载不需要它们的AsyncOperationHandle.Result发布的接口，但仍需要释放操作本身。例如Addressables.LoadResourceLocationsAsync和Addressables.GetDownloadSizeAsync。它们加载你可以访问的数据，直到释放操作为止。
```c#

        AsyncOperationHandle<long> getDownloadSize = Addressables.GetDownloadSizeAsync(key);
        Addressables.Release(getDownloadSize);

        
        AsyncOperationHandle downloadDependencies = Addressables.DownloadDependenciesAsync(key);
        Addressables.Release(downloadDependencies);
```
5. Background interactions（后台交互）  
AsyncOperationHandle.Result字段中不返回任何内容的操作有一个可选参数autoReleaseHandle，将autoReleaseHandle设置为true，可在完成时自动释放Handle。
```c#
Addressables.DownloadDependenciesAsync(key,true);
Addressables.UnloadScene(scene,true);
```

### 内存清理
不再引用的asset不代表它已被卸载，例如：  
一个assetbundle(stuff)中有三个asset(tree,tank,cow),当tree被加载时，tree会有一个引用计数，stuff也有一个引用计数；  
当tank被加载时，tank有一个引用计数，而stuff引用计数为2；  
当tree被释放时，tree的引用计数为0，但tree并未被卸载。因为可以加载Assetbundle中的部分asset，但不能卸载部分asset。

### Delaying Unload
应避免频繁的将asset加载，释放，又重新加载，例如：  
有两个materials，boat和plane，它们共享同一个在一个AssetBundle中的texture(cammo)；  
当关卡1时加载boat，离开关卡1时释放boat，进入关卡2时加载plane，这会导致cammon被加载后，又被卸载，又立马被加载。  
这种情况下，应该推迟卸载boat，可以设计wrapper来延迟Release调用。  


### AssetBundle内存消耗

#### Serialized File Overhead
当unity加载一个AssetBundle时，它为AssetBundle中的每个Serialized文件分配一个内部buffer，这个buffer在AssetBundled的生存期中一直存在。非场景的AssetBundle包含一个Serialized File，包含场景的AssetBundle中的每个场景最多包含两个Serialized File（一个scene对应2个Serialized File）。  
每个Serialized File还为文件中的每个对象类型包含了一个TypeTree，TypeTree描述了每个object类型的数据布局，并允许你加载反序列化的对象。  
当加载AssetBundle并将其保存在内存中时，将加载所有TypeTree。  
当将相同类型的对象放入多个AssetBundle中时，这些对象的类型信息会在每个AssetBundle的TypeTree中重复。当使用许多小型AssetBundle时，这种类型信息的重复会更加明显。可以通过在禁用和不禁用TypeTree的情况下进行构建并比较大小来测试TypeTree对AssetBundle大小的影响。如果测量后发现重复的TypeTree内存开销是不可接受的，则可以通过将相同类型的对象打包到相同的AssetBundles中来避免这种情况。  

#### AssetBundle Object


## Addressables FAQ
###  许多小的Bundles和几个大的Bundles哪个更好？  
有几个关键因素可以决定要生成多少个bundles。  
通过group的大小和build设置来控制bundles的数量：
点击某个group,在`Advanced Options/Bundle Mode`下
* `Pack Together`则将该group构建为一个bundle
* `Pack Separately`则该group下每个asset为一个bundle
* `Pack Together By Label`则该group下相同label的asset为一个bundle  
也可修改Group模板，在`Assets/AddressableAssetsData/AssetGroupTemplates`下选择模板，修改其`Advanced Options/Bundle Mode`，则之后按照该模板创建的group都有同样的bundle mode。（group模板选择在`AddressableAssetsData/Windows/AddressableAssetSettings`的AssetGroupTemplates）  
还可以通过代码设置BundleMode：
```c#
        BundledAssetGroupSchema bundledAssetGroupSchema = new BundledAssetGroupSchema();
        bundledAssetGroupSchema.BundleMode = BundledAssetGroupSchema.BundlePackingMode.PackSeparately;
```
一旦知道如何控制bundle布局，那么如何设置bundle取决于具体游戏。以下是有助于做出决定的关键数据  
* bundles过多的缺点：
    1. 每个bundle都有内存消耗。如果一次将100甚至1000个bundles加载到内存，则内存会消耗明显。
    2. 下载bundles有并发限制。如果一次要下载1000个需要bundles,它们并不能在同时都下载完。
    3. bundle信息可能会使catalog臃肿。为了能够下载和加载catalog，unity存储了有关bundle的基于string的信息，数量很大的bundles会大大增加catalog的大小。
    4. asset重复性的可能性更大。假设两个materials被标记为Addressable,它们依赖于同一个texture。如果这两个material在同一个bundle中，那这个texture只会被放进bundle中一次，并被它们一起引用。如果这两个material在不同的bundle中，而texture并未标记未Addressable,那它就会被重复引用。

* bundles太少的缺点：  
    1. 用来进行下载的UnityWebRequest 在下载失败后不会在原处恢复下载，因此如果正在下载大型bundle，而用户断开连接，那么当用户重新获得连接时，会重头重新开始下载bundle包。
    2. 可以从bundle包中单独加载asset，但不能单独卸载asset。

### 最佳压缩设置是什么？
Addressables 提供了三种不同的选项供bundle压缩：Uncompressed, LZ4, LZMA。 通常LZ4 用来压缩本地内容，LZMA 用来压缩远程。  
你可以在`Advanced Options - Asset Bundle Compression `中为每个group设置不同的压缩选项，压缩不会影响已经加载后的内容所占内存大小。  
* Uncompressed   
所占磁盘最大但通常加载最快的选项。如果游戏有剩余空间，那么本地内容可以考虑这种选项。  
Uncompressed bundle的主要优势关键在于如何处理补丁。如果你开发的平台提供修补程序（例如switch,steam），Uncompressed bundle可以提供最准确（最小）的修补。别的压缩方式都会引起一些补丁膨胀。  
* LZ4   
如果Uncompressed不合适，那么LZ4应该被用来压缩所有本地内容。这是基于块的压缩，它提供了加载文件某些部分的功能，而无需完全加载它。
* LZMA   
LZMA应该用来压缩远端资源，不能压缩本地资源。它提供了最小的bundle大小，但加载很慢。如果你要将本地资源用LAMA压缩成bundle,可以创建一个小的player,但加载时间比Uncompressed和LZ4长很多。  
对于下载的bundles，当将它存储到缓存中时，我们可以重新压缩下载的包来避免加载时间过长。默认情况下，bundles将以未压缩的方式存储在缓存中。如果你希望使用LZ4压缩缓存，可以通过创建CacheInitializationSettings来实现。  
注意：平台的硬件特性可能意味着未压缩的bundles并非总是加载最快的。加载未压缩bundles的最大速度由IO速度控制，而加载LZ4压缩bundles的速度可以由IO速度或CPU决定，具体取决于硬件。在大多数平台上，加载LZ4压缩的bundles受CPU限制，并且加载未压缩的bundles会更快。在IO速度较低且CPU速度较高的平台上，LZ4加载会更快。进行性能分析以验证您的游戏是否适合通用模式或需要进行一些特殊的调整，始终是一个好习惯。

### 有什么方法可以减小catalog大小？
有两种优化方式：
1. 压缩本地catalog  
如果最关心build中catalog的大小，那么可以在`AddressableAssetsData/Windows/AddressableAssetSettings`中勾选` Compress Local Catalog`。这会使catalog文件更小，但同时加载时间会变长。
2. 禁用内置Scene和Resources  
Addressables提供了从Resources和内置Scenes列表中加载内容的功能，默认这项是开启的，这会导致catalog size变大。如果不需要这项功能，可以在`Built In Data`group中，将`Include Resources Folders`和`Include Build Settings Scenes`取消勾选。  
取消选中这些选项只会从Addressables目录中删除对那些资产类型的引用。


### 什么是addressables_content_state？
每次使用Addressables进行build后，都会生成一个addressables_content_state.bin文件，路径在`Assets/AddressableAssetsData/Windows/AddressableAssetSettings`中`Content State build Path`设置，若该路径为空，则默认放在`Assets/AddressableAssetsData/<Platform>/`文件夹下。  
这个文件对于内容更新工作流至关重要。如果不对任何内容进行更新，那可以完全忽略该文件。如果要进行内容更新，则需要先前版本生成的该文件。

### 规模可能有什么影响？
当项目越来越大时，关注有关asset和bundle的以下几点：
* bundle总大小  
建议bundle包的总大小不要超过4GB
* 子级assets会影响Addressables Group UI性能  
在group的面板下，` Tools > Show Sprite and Subobject Addresses`  
没有硬性限制，但如果有很多assets,这么asset又有很多子assets，最好关闭sub-asset显示。这个选项只会影响group中数据的显示，不影响在运行时的加载。禁用此功能将使UI更具响应性。 
*  group层次结构显示  
在`Assets/AddressableAssetsData/Windows/AddressableAssetSettings`中 `Group Hierarchy with Dashes`  
如果勾选，名称中包含`-`的group将显示为好像破折号代表文件夹层次结构。这不影响实际的group名称和build。 例如有两个group分别叫`x-y-z`和`x-y-w`，那么它们显示在好像名为`x`的文件夹中，`x`文件夹里有一个`y`文件夹，`y`文件夹包含两个group`x-y-z`和`x-y-w`。这不影响UI响应，只是使得当有大量group时查询更容易。
* Bundle设计
bundle的数量和大小
# vcpkg
命令行包管理工具，极大简化常用依赖包的管理。它提供一系列简单的命令，自动下载源码（非二进制文件）然后使用机器上最新的Visual Studio编译器编译成三方库，这种方式减少了二进制不兼容的可能性。  
## Windows x64安装
1. 打开PowerShell选择合适路径（无空格），运行`git clone https://github.com/microsoft/vcpkg`  
2. 运行` .\vcpkg\bootstrap-vcpkg.bat`  
3. 设置环境变量  
3. 安装libraries，例如lua。 版本选择`x64-windows-static`。 命令如：`vcpkg install lua:x64-windows-static`

# CL
cl.exe 是一种工具，用于控制 Microsoft c + + (MSVC) C 和 c + + 编译器和链接器。 cl.exe 只能在支持 Windows Microsoft Visual Studio 的操作系统上运行。只能从 Visual Studio 开发人员命令提示启动此工具。  
1. 设置vscode `setting.json`,添加依赖包路径  
```json
    "C_Cpp.default.includePath": ["D:/vcpkg/installed/x64-windows/include"]
```
2. 运行cl指令，添加lua.lib和include路径  
    1. `cl main.c lua.lib -I "D:\vcpkg\installed\x64-windows-static\include" -link -LIBPATH:"D:\vcpkg\installed\x64-windows-static\lib" `  
    2. `./main.exe`  


# macOS安装vcpkg
1. $ xcode-select --install
2. cd ~
   mkdir bin
   cd bin
   git clone 
3. 装powershell 
   github  powershell-7.0.4-osx-x64.tar.gz
   打开terminal -> shell从 /bin/bash设置为 /Users/lijun/bin/powershell/pwsh
   nano $profile 
   $env:VCPKG_ROOT=/Users/lijun/bin/vcpkg


# Lua与C交互
Lua和C/C++交互的基础是虚拟栈，Lua提供了一系列C API用于操作栈。   

堆栈索引的方式可是是正数也可以是负数，区别是：正数索引1永远表示栈底，负数索引-1永远表示栈顶。  

数据交互：  

* 当C要调用Lua数据时，Lua把值压入栈中，C再从栈中取值；  

* 当Lua调用C数据时，C要将数据压入栈中，让Lua从栈中取值。  

函数交互：   

* 当C要调用Lua函数时，Lua先将Lua函数压入栈中，C再将数据（作为参数）继续压入栈中，然后使用C API调用栈上的lua函数+参数，调用完后，Lua函数和参数都会出栈，而函数计算后的返还值会压入栈中； 

* 当Lua要调用C函数时，需要通过API注册符合lua规范的C函数，来让Lua知道该C函数的定义。每一个C函数（闭包）都会分配一个独立的栈，栈中初始的内容是C函数需要的参数，C函数从栈中取出参数值，执行完毕后将返回结果压入栈。  


# 示例

## 堆栈操作的简易示例
```cpp
#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
int main(int argc, const char *argv[]) {

    lua_State *state= luaL_newstate();//创建Lua状态机
    lua_pushstring(state, "hi lua");//入栈 压入string到栈中
    lua_pushnumber(state, 100);//入栈 压入number到栈中
    //从栈中取值
    if (lua_isnumber(L, -1)) { //这里的index也可以是2 （-1：栈顶）
        printf("[line:%d] lua_tonumber(L, 2):%f\n", __LINE__, lua_tonumber(L, 2));
    }
    if (lua_isstring(L, -2)) { //这里的index也可以是1 （1：栈底）
        printf("[line:%d] lua_tostring(L, 1):%s\n", __LINE__, lua_tostring(L, 1));
    }
    lua_close(L);//关闭state
    return 0;
}
```  
## C加载Lua文件

qux.lua  
```lua
return 10;
```
main.c 
```cpp
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
int main()
{
    lua_State *state= luaL_newstate();//创建Lua状态机
    luaL_openlibs(state);//打开指定状态机中的所有 Lua 标准库
    char* filename="qux.lua";
    //luaL_loadfile:把一个文件加载为 Lua 代码块,使用 lua_load 加载文件中的数据。
    //lua_load: 加载一段 Lua 代码块，但不运行。如果没有错误，lua_load把一个编译好的代码块作为一个 【Lua 函数】压到栈顶
    //lua_pcall(state,参数个数，返回值个数，错误处理函数[表示错误处理函数在栈中的索引,0表示无]):以保护模式调用一个函数（此处是上一步通过LuaL_loadfile压入的lua函数）
    if(luaL_loadfile(state,filename) || lua_pcall(state,0,1,0)){
        printf("load Lua script failed: %s\n", lua_tostring(state, -1));
        return NULL;
    }
    printf("%g\n",lua_tonumber(state,-1));//10
    lua_close(state);
    return 0;
}
```


## C调用Lua函数

qux.lua  
```lua
mult=function (a,b)
    return a*b
end
```
main.c 
```cpp
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
int main()
{
    lua_State *state= luaL_newstate();//创建Lua状态机
    luaL_openlibs(state);//打开指定状态机中的所有 Lua 标准库
    char* filename="qux.lua";
    if(luaL_loadfile(state,filename) || lua_pcall(state,0,0,0)){
        printf("load Lua script failed: %s\n", lua_tostring(state, -1));
        return NULL;
    }
    lua_getglobal(state,"mult");//将mult压入栈中
    lua_pushnumber(state,2);//压入参数
    lua_pushnumber(state,3);//压入参数
    if(lua_pcall(state,2,1,0)!=0){//传入参数调用函数，将返回结果压入栈中
        printf("lua_pcall failed: %s\n",lua_tostring(state,-1));
        return NULL;
    }
    int result=lua_tonumber(state,-1);//获取返回结果
    printf("result is %d\n",result);
    lua_close(state);
    return 0;
}
```


## C修改Lua中的table

qux.lua  
```lua
str = "Hello, Lua !"
tab = {
    name = "Polly",
    id = 123456,
    mult=function (a,b)
         return a*b
    end,
}
```
main.c 
```cpp
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
int main()
{
    //========在lua中的table中中插入table==========================
    lua_State *state=luaL_newstate();
    luaL_openlibs(state);
    char* filename="qux.lua";
    if(luaL_loadfile(state,filename) || lua_pcall(state,0,0,0)){
        printf("load Lua script failed: %s\n", lua_tostring(state, -1));
        return NULL;
    }
    lua_getglobal(state,"info"); //获取qux.lua文件中的info={}
    lua_newtable(state); // 创建新table { }
    lua_pushstring(state,"path"); //key
    lua_pushstring(state,"user/local/..."); //value
    lua_settable(state,-3);
    lua_setfield(state,-2,"mysearcher"); //mysearcher={path="user/local/..."}

    lua_getfield(state,-1,"mysearcher"); //获取tab{}中的mysearcher{}
    lua_getfield(state,-1,"path");//获取mysearcher{}中的path
    printf("path : %s\n",lua_tostring(state,-1));//输出： path: user/local/...

    //==========调用table中的function====================================
    lua_getglobal(state,"tab");
    lua_getfield(state,-1,"mult");
    lua_pushnumber(state,2);
    lua_pushnumber(state,3);
    if(lua_pcall(state,2,1,0)!=0){
        printf("lua_pcall failed: %s\n",lua_tostring(state,-1));
        return NULL;
    }
    char* result=lua_tostring(state,-1);
    printf("result is %s\n",result);

    printf("-------------------------------\n");
    //=========修改table中的字段的值==========================================
    lua_pushstring(state,"Lisa"); //传入值
    lua_setfield(state,1,"name"); //修改值
    
    lua_getglobal(state,"tab");
    lua_getfield(state,-1,"name");
    printf("name is %s\n",lua_tostring(state,-1));

    printf("-------------------------------\n");
    //==========在table中插入新的字段并赋值=======================================
    lua_pushstring(state,"new-field");
    lua_setfield(state,-3,"newstr");

    lua_getglobal(state,"tab");
    lua_getfield(state,-1,"newstr");
    printf("newstr is %s\n",lua_tostring(state,-1));

    lua_close(state);
    return 0;
}
```




## Lua调用C函数

```cpp
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
//所有的函数必须接收一个lua_State作为参数，同时返回一个整数值。
//因为这个函数使用Lua栈作为参数，所以它可以从栈里面读取任意数量和任意类型的参数
//而这个函数的返回值则表示函数返回时有多少返回值被压入Lua栈
//typedef int (*lua_CFunction) (lua_State *L);
//待lua调用的c注册函数
int c_addsub(lua_State *state){
    double a = luaL_checknumber(state,1);
    double b = luaL_checknumber(state,2);
    lua_pushnumber(state, a+b);
    lua_pushnumber(state, a-b);
    return 2;
}
// 将C模块中要导出的C函数放入到luaL_Reg结构体数组内
const struct luaL_Reg Libs[] = {
    {"addsub", c_addsub},
    {NULL, NULL} // 以NULL标识结束
};
int main(){
    lua_State *state=luaL_newstate();
    luaL_openlibs(state);
     //1.注册C函数
     lua_pushcfunction(state,c_addsub);
     lua_setglobal(state,"addsub");


    //2. 注册C函数
    lua_register(state,"addsub",c_addsub);
    lua_getglobal(state,"addsub");

    //3. 注册模块组
    luaL_newlib(state, Libs);

    lua_setglobal(state,"mylib");
    lua_getglobal(state,"mylib");
    lua_getfield(state,-1,"addsub");
    
    lua_close(state);

    return 0;
}
```  

可将c文件打包成dll文件，通过`require('mylib')`调用mylib里的C函数。
mylib.c
```cpp
#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
//=================将C函数编译为动态库文件========================
//待lua调用的c注册函数
static int c_addsub(lua_State *state){
    double a = luaL_checknumber(state,1);//检查栈中的参数是否合法，1表示Lua调用时的第一个参数(从左到右)
    double b = luaL_checknumber(state,2);//如果传递的参数不为number，将报错并终止执行
    lua_pushnumber(state, a+b);//将结果压入栈中
    lua_pushnumber(state, a-b);//将结果压入栈中
    return 2;//返回值数量
}

// 将C模块中要导出的C函数放入到luaL_Reg结构体数组内
static const struct luaL_Reg mylib[] = {
    {"addsub", c_addsub},
    {NULL, NULL} // 以NULL标识结束
};

//入口函数 在导入C库时调用 完成对库中导出的函数的注册
int luaopen_mLualib(lua_State *state)  
{  
    luaL_newlib(state, mylib);    
    return 1;       // 把Lib表压入了栈中，所以就需要返回1  
}
```

## 自定义searcher
```cpp
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
//自定义searcher
int my_searcher(lua_State * state){
    const char *name = lua_tostring(state,-1);
    if(strcmp(name,"oop")){
        lua_pushstring(state,"Not found.");
        return 1;
    }
    luaL_loadstring(state,"return {a=10}");
    lua_pushstring(state,"oop.assetbundle");
    return 2;
}

int main(){
    lua_State *state=luaL_newstate();
    luaL_openlibs(state);
    lua_getglobal(state,"package");
    lua_getfield(state,-1,"searchers");
    lua_pushcfunction(state,my_searcher);
    lua_seti(state,-2,5);

    luaL_loadstring(state,"local oop=require('oop'); print(oop.a)");
    lua_pcall(state,0,0,0);
    lua_close(state);
    return 0;
}
```


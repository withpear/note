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


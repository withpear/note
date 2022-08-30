```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="MyMauiApp.MainPage">
    <StackLayout>
        <Slider VerticalOptions="Center" />
         <Editor x:Name="TextEditor"/>
        <Button Text="Click Me!" />
    </StackLayout>
</ContentPage>
```

* xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
xml namespace 默认命名空间，<StackLayout> <Slider>等都来自该命名空间  
也可为它添加别名，例如 xmlns:a="http://schemas.microsoft.com/dotnet/2021/maui"，那相对应的<StackLayout>等也要变成<a:StackLayout>

* xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
x表示指向"http://schemas.microsoft.com/winfx/2009/xaml"命名空间的别名，因为一个ContentPage中只能有一个默认命名空间

* x:Class="MyMauiApp.MainPage"
Class是x表示的命名空间里的一个属性，在此将MyMauiApp.MainPage赋值给它

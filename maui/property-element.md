```xml
<Label Text="Hello" TextColor="Aqua"></Label>
```
Label是object element，它是一个表示为 XML 元素的 .NET MAUI 对象  
TextColor是property attribute，它是表示为 XML 属性的 .NET MAUI 属性

```xml
<!--property-element syntax-->
<Label Text="Hello"> 
    <Label.TextColor>Aqua</Label.TextColor>
</Label>
```
Label是object element  
TextColor是property element，它是一个表示为 XML 元素的 .NET MAUI 属性

* 当属性的值太复杂而无法表示为简单字符串时，则需要使用property-element syntax

```xml
<!--property-element syntax 示例-->
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="Notes.Views.GridTest"
             Title="GridTest">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="100"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="100"/>
        </Grid.ColumnDefinitions>
        <Label Text="hello" TextColor="Silver" BackgroundColor="Red" 
               Grid.Column="0" Grid.Row="0"/>
        <Label Text="world" TextColor="Blue" BackgroundColor="Gray" 
               Grid.Column="0" Grid.Row="1"
               Grid.ColumnSpan="2"/>
        <Label Text="peace" TextColor="Blue" BackgroundColor="Green" 
               Grid.Column="0" Grid.Row="2"/>
    </Grid>
</ContentPage>
```
* 以上例子中Grid对象被设置为ContentPage的Content属性。
* 在XAML中没有指明Content属性是因为任何指定为类的ContentProperty的属性意味着不需要在XAML标记
```c#
[ContentProperty("Content")]
public class ContentPage : TemplatedPage
{
    ...
}
```
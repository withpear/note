```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"

             xmlns:local="clr-namespace:XamlSamples"

             xmlns:sys="clr-namespace:System;assembly=netstandard">

    <ContentPage.Resources>
        <LayoutOptions x:Key="horOptions" Alignment="Center"/>

        <x:Double x:key="borderWidth">3</x:Double>

        <OnPlatform x:Key="textColor" x:TypeArguments="Color">
            <On Platform="iOS" Value="Red" />
            <On Platform="Android" Value="Aqua" />
            <On Platform="WinUI" Value="#80FF80" />
        </OnPlatform>

    </ContentPage.Resources>


             <!--StaticResource-->
    <Button HorzontalOptions="{StaticResource horOptions}"
            BorderWidth="{StaticResource borderWidth}"
            TextColor="{StaticResource textColor}"/>

             <!--x:Static-->
    <Label Text="Hello, XAML!"
        TextColor="{x:Static local:AppConstants.BackgroundColor}"
        BackgroundColor="{x:Static local:AppConstants.ForegroundColor}"

        FontAttributes="Bold"
        FontSize="30"
        HorizontalOptions="Center" />
        
      <BoxView WidthRequest="{x:Static sys:Math.PI}"
               HeightRequest="{x:Static sys:Math.E}"
               Color="{x:Static local:AppConstants.ForegroundColor}"
               HorizontalOptions="Center"
               VerticalOptions="CenterAndExpand"
               Scale="100" />
</ContentPage>
```
# Weather IOS App

<img src="https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Weathericon.png" width="250" style="border-radius: 50%;"/>

## Screenshots from my iPhone device

<div style="display:flex;flex-wrap: wrap;">
  <img src="https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Screenshot5.png" width="300"/>
  <img src="https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Screenshot1.png" width="300"/>
  <img src="https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Screenshot2.png" width="300"/>
  <img src="https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Screenshot4.png" width="300"/>
  <img src="https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Screenshot3.png" width="300"/>
</div>

## App Features

1. **UIKit**
2. **CoreLocation**: Obtain the user's current location and handle location updates.
3. **MapKit**: Retrieve location data based on user search.
4. **URLSession**: Make network requests.
5. **GCD (Grand Central Dispatch)**: Perform tasks asynchronously.
6. **UserDefaults**: Store weather location data and user preferences on the device.

## Usage

1. Create an account on [OpenWeatherAPI](https://openweathermap.org/) and copy the API Key from your account.
2. Paste the API Key into the build configuration `AppConfig` file in the app's bundle:

   ![Screenshot](https://github.com/aelmaar/Weather-IOS-App/blob/main/weather%20screenshots/Screenshot6.png)

3. Run Xcode and enjoy 😊

> [!Note]
> The iOS simulator doesn't automatically use your current location. You need to manually set a predefined or custom location in the simulator:
> - In the simulator, go to the top menu and select `Features > Location`.
> - Choose from several predefined locations such as "Apple" (Apple's headquarters), "City Run," "Freeway Drive," etc.
> - To set a specific location, select `Custom Location...` and enter the latitude and longitude of the desired location.
> - On a real iPhone device, the app will use your actual current location.

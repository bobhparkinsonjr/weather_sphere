import 'package:flutter/material.dart';
import '../utilities/world_location.dart';
import '../weather/weather_info.dart';
import '../weather/open_weather_map.dart';
import '../utilities/settings_manager.dart';
import 'single_weather_info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          await SettingsManager.setup();
          await WorldLocation.requestLocationAccessPermission();
          WorldLocation worldLocation = await WorldLocation.getCurrentLocation();
          worldLocation.log();
          WeatherInfo weatherInfo = OpenWeatherMap();
          // await weatherInfo.updateWorldLocation(worldLocation);
          // await weatherInfo.updateNamedLocation('Los Angeles', 'CA', 'US');
          await weatherInfo.updateNamedLocation('Anaheim', 'CA', 'US');
          // weatherInfo.log();
          // await weatherInfo.save('${SettingsManager.getFolder()}weather_testing.json');
          // await weatherInfo.load('${SettingsManager.getFolder()}weather_testing.json');
          // weatherInfo.log();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleWeatherInfoScreen(), // weatherInfo: weatherInfo),
            ),
          );
        },
        child: Container(
          child: Center(
            child: Text(
              "Home Screen",
              style: TextStyle(
                fontSize: 14,
                color: Colors.yellow,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

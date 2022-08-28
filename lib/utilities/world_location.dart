import 'package:geolocator/geolocator.dart';
import '../devtools/logger.dart';
import '../weather/weather_info.dart';

class WorldLocation {
  double longitude;
  double latitude;

  WorldLocation({this.longitude = 0.0, this.latitude = 0.0});

  static Future<WorldLocation> getCurrentLocation() async {
    WorldLocation retVal = WorldLocation();

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(
          seconds: 30,
        ),
      );

      retVal.latitude = position.latitude;
      retVal.longitude = position.longitude;
    } catch (e) {
      Logger.print('there was a problem retrieving the current position with Geolocator | exception: \'${e.toString()}\'');
    }

    return retVal;
  }

  void log() {
    Logger.print('world location: < $longitude, $latitude >');
  }

  static Future<void> requestLocationAccessPermission() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
  }

  Future<WeatherInfo> createWeatherInfo() async {
    WeatherInfo weatherInfo = WeatherInfo.createWeatherInfo();
    await weatherInfo.updateWorldLocation(this);
    return weatherInfo;
  }
}

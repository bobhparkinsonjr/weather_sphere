import 'weather_info.dart';
import '../utilities/settings_manager.dart';
import '../utilities/world_location.dart';
import '../utilities/named_location.dart';

class WeatherManager {
  static WeatherInfo _weatherInfoCurrentLocation = WeatherInfo();
  static WeatherInfo _weatherInfoNamedLocation = WeatherInfo();

  static WeatherInfo getWeatherInfo() {
    if (SettingsManager.getUseCurrentLocation()) return _weatherInfoCurrentLocation;
    return _weatherInfoNamedLocation;
  }

  static Future<void> updateWeatherInfo() async {
    if (SettingsManager.getUseCurrentLocation() || !(SettingsManager.hasLocationInfo())) {
      if (!(_weatherInfoCurrentLocation.isValid()) || _weatherInfoCurrentLocation.isLastApiCallExpired()) {
        await WorldLocation.requestLocationAccessPermission();
        WorldLocation worldLocation = await WorldLocation.getCurrentLocation();
        _weatherInfoCurrentLocation = await worldLocation.createWeatherInfo();
        // if (_weatherInfoCurrentLocation.isValid()) {
        //   await _weatherInfoCurrentLocation.save('${SettingsManager.getFolder()}current_location.json');
        // }
      }
    } else {
      NamedLocation namedLocation = SettingsManager.getSelectedLocation();
      _weatherInfoNamedLocation = await namedLocation.updateWeatherInfo();
    }
  }
}

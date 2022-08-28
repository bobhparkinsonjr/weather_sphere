import '../utilities/settings_manager.dart';

import '../weather/weather_info.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class NamedLocation {
  late String city;
  late String state;
  late String country;

  WeatherInfo _weatherInfo = WeatherInfo();

  NamedLocation({this.city = '', this.state = '', this.country = ''});

  String getDisplayFullLocation() {
    String v = city;

    if (state.isNotEmpty) v += ', $state';

    v += ', $country';

    return v;
  }

  // does not include folder or extension
  String getFileName() {
    String v = '';

    if (city.isNotEmpty) v += city;

    if (state.isNotEmpty) {
      if (v.isNotEmpty) v += '_';
      v += state;
    }

    if (country.isNotEmpty) {
      if (v.isNotEmpty) v += '_';
      v += country;
    }

    return v;
  }

  Future<WeatherInfo> updateWeatherInfo() async {
    // NOTE: if supporting more than one provider, then use the provider name from SettingsManager here to help
    //       form the file path

    String weatherInfoFilePath = '${SettingsManager.getFolder()}named_location_${getFileName()}.json';

    if (!(_weatherInfo.isValid())) {
      _weatherInfo = WeatherInfo.createWeatherInfo();
      await _weatherInfo.load(weatherInfoFilePath);
    }

    if (!(_weatherInfo.isValid()) || _weatherInfo.isLastApiCallExpired()) {
      _weatherInfo = WeatherInfo.createWeatherInfo();
      await _weatherInfo.updateNamedLocation(city, state, country);

      if (_weatherInfo.isValid() && !(_weatherInfo.isError())) {
        await _weatherInfo.save(weatherInfoFilePath);
      }
    }

    // weatherInfo.log();

    return _weatherInfo;
  }

  @override
  bool operator ==(Object other) {
    return ((other is NamedLocation) && other.city == city && other.state == state && other.country == country);
  }

  @override
  int get hashCode => Object.hash(city, state, country);

  Map toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
    };
  }

  NamedLocation.fromJson(dynamic jsonObject) {
    city = jsonObject['city'];
    state = jsonObject['state'];
    country = jsonObject['country'];
  }
}

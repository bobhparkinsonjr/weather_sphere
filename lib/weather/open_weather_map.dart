import 'weather_info.dart';

// you will need to create this file and place the following in it to use Open Weather Map:
// const String kOpenWeatherMapApiKey = 'my api key goes here';
import '../config/open_weather_map_config.dart';

import '../utilities/network_tools.dart';
import '../utilities/world_location.dart';

import '../devtools/logger.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class OpenWeatherReport extends WeatherReport {
  OpenWeatherReport(dynamic jsonObject) {
    dt = DateTime.fromMillisecondsSinceEpoch(jsonObject['dt'] * 1000, isUtc: true);

    temperatureFahrenheit = jsonObject['main']['temp'].toDouble();
    minTemperatureFahrenheit = jsonObject['main']['temp_min'].toDouble();
    maxTemperatureFahrenheit = jsonObject['main']['temp_max'].toDouble();

    if (jsonObject['main']['humidity'] != null)
      percentHumidity = jsonObject['main']['humidity'].toDouble();
    else
      percentHumidity = -1.0;

    int conditionCode = jsonObject['weather'][0]['id'];
    weatherCondition = OpenWeatherMap.getWeatherCondition(conditionCode);

    if (jsonObject['pop'] != null)
      percentChanceOfRain = jsonObject['pop'] * 100.0;
    else
      percentChanceOfRain = 0.0;
  }
}

class OpenWeatherMap extends WeatherInfo {
  final String _apiCurrentWeather = 'https://api.openweathermap.org/data/2.5/weather';
  final String _apiForecastWeather = 'https://api.openweathermap.org/data/2.5/forecast';

  static const int kMinIntervalApiCallsMS = 1000 * 60 * 60 * 1;

  @override
  bool isLastApiCallExpired() {
    int lastApiCallElapsedMS = getLastApiCallElapsedMS();
    return (lastApiCallElapsedMS <= 0 || lastApiCallElapsedMS >= kMinIntervalApiCallsMS);
  }

  Future<void> _update(String urlCurrentWeather, String urlForecastWeather) async {
    if (!(isLastApiCallExpired())) {
      Logger.print('last api call was too recent, will keep existing values');
      return;
    }

    Logger.print('checking Open Weather Map for weather info');

    setError(false);

    Future<dynamic> futureCurrentWeather = NetworkTools.httpGetJson(urlCurrentWeather);
    Future<dynamic> futureForecastWeather = NetworkTools.httpGetJson(urlForecastWeather);

    dynamic responseCurrentWeather = await futureCurrentWeather;
    dynamic responseForecastWeather = await futureForecastWeather;

    Logger.print('retrieved weather info from Open Weather Map');

    setLastApiCallNow();

    reports = [];

    try {
      if (responseCurrentWeather != null) {
        city = responseCurrentWeather['name'];
        country = responseCurrentWeather['sys']['country'];
        longitude = responseCurrentWeather['coord']['lon'];
        latitude = responseCurrentWeather['coord']['lat'];

        reports.add(OpenWeatherReport(responseCurrentWeather));
      }

      if (responseForecastWeather != null) {
        int totalForecastEntries = responseForecastWeather['list'].length;
        // Logger.print('found $totalForecastEntries forecast entries');

        for (int forecastIndex = 0; forecastIndex < totalForecastEntries; ++forecastIndex) {
          // Logger.print('looking at forecast entry $forecastIndex');
          reports.add(OpenWeatherReport(responseForecastWeather['list'][forecastIndex]));
        }
      }
    } catch (e) {
      Logger.print('failed to parse response from Open Weather Map | exception: \'${e.toString()}\'');
    }

    if (reports.isEmpty) {
      // TODO: adding a dummy report for now to ensure app doesn't block waiting on a valid report
      WeatherReport weatherReport = WeatherReport();
      weatherReport.dt = DateTime.now().toUtc();
      reports.add(weatherReport);

      setError(true);
    }

    updateDailyInfo();
  }

  @override
  Future<void> updateWorldLocation(WorldLocation worldLocation) async {
    String urlCurrentWeather =
        '$_apiCurrentWeather?lat=${worldLocation.latitude}&lon=${worldLocation.longitude}&appid=$kOpenWeatherMapApiKey&units=imperial';
    String urlForecastWeather =
        '$_apiForecastWeather?lat=${worldLocation.latitude}&lon=${worldLocation.longitude}&appid=$kOpenWeatherMapApiKey&units=imperial';

    await _update(urlCurrentWeather, urlForecastWeather);
  }

  // state and country here are expected to be ISO codes
  @override
  Future<void> updateNamedLocation(String city, String state, String country) async {
    this.state = state;

    String location = '';

    if (city.isNotEmpty) {
      location += city;

      if (state.isNotEmpty && country.isNotEmpty) {
        location += ',$state';
      }

      if (country.isNotEmpty) {
        location += ',$country';
      }
    }

    String urlCurrentWeather = '$_apiCurrentWeather?q=$location&appid=$kOpenWeatherMapApiKey&units=imperial';
    String urlForecastWeather = '$_apiForecastWeather?q=$location&appid=$kOpenWeatherMapApiKey&units=imperial';

    await _update(urlCurrentWeather, urlForecastWeather);
  }

  @override
  String getServiceProviderDisplayName() {
    return 'Open Weather Map';
  }

  static WeatherCondition getWeatherCondition(int conditionCode) {
    if (conditionCode >= 200 && conditionCode < 300) return WeatherCondition.thunderstorm;
    if (conditionCode >= 300 && conditionCode < 400) return WeatherCondition.drizzle;
    if (conditionCode >= 500 && conditionCode < 600) return WeatherCondition.rain;
    if (conditionCode >= 600 && conditionCode < 700) return WeatherCondition.snow;
    if (conditionCode == 701) return WeatherCondition.mist;
    if (conditionCode == 711) return WeatherCondition.smoke;
    if (conditionCode == 721) return WeatherCondition.haze;
    if (conditionCode == 731) return WeatherCondition.dust;
    if (conditionCode == 741) return WeatherCondition.fog;
    if (conditionCode == 751) return WeatherCondition.sand;
    if (conditionCode == 761) return WeatherCondition.dust;
    if (conditionCode == 762) return WeatherCondition.ash;
    if (conditionCode == 771) return WeatherCondition.squall;
    if (conditionCode == 781) return WeatherCondition.tornado;
    if (conditionCode == 800) return WeatherCondition.clear;
    if (conditionCode >= 801 && conditionCode < 900) return WeatherCondition.clouds;

    return WeatherCondition.unknown;
  }
}

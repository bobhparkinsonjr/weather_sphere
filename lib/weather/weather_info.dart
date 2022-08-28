import 'dart:io';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

import '../utilities/world_location.dart';
import '../devtools/logger.dart';
import 'open_weather_map.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

enum WeatherCondition {
  unknown,
  thunderstorm,
  drizzle,
  rain,
  snow,
  mist,
  smoke,
  haze,
  dust,
  fog,
  sand,
  ash,
  squall,
  tornado,
  clear,
  clouds,
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class WeatherReport {
  DateTime dt = DateTime.utc(2000);

  double temperatureFahrenheit = 0.0;

  // these should only be used when min <= max
  double minTemperatureFahrenheit = 1.0;
  double maxTemperatureFahrenheit = -1.0;

  WeatherCondition weatherCondition = WeatherCondition.unknown;

  double percentChanceOfRain = 0.0;
  double percentHumidity = -1.0;

  String getLogDescription() {
    return '$dt | temperature: $temperatureFahrenheit ($minTemperatureFahrenheit,$maxTemperatureFahrenheit) | condition: $weatherCondition | rain: $percentChanceOfRain% | humidity: $percentHumidity%';
  }

  WeatherReport();

  WeatherReport.clone(WeatherReport other) {
    dt = DateTime.utc(other.dt.year, other.dt.month, other.dt.day, other.dt.hour, other.dt.minute, other.dt.second,
        other.dt.millisecond, other.dt.microsecond);
    temperatureFahrenheit = other.temperatureFahrenheit;
    minTemperatureFahrenheit = other.minTemperatureFahrenheit;
    maxTemperatureFahrenheit = other.maxTemperatureFahrenheit;
    weatherCondition = other.weatherCondition;
    percentChanceOfRain = other.percentChanceOfRain;
    percentHumidity = other.percentHumidity;
  }

  WeatherReport.fromJson(dynamic jsonObject) {
    fromJson(jsonObject);
  }

  void updateDay(WeatherReport r) {
    if (r.minTemperatureFahrenheit < minTemperatureFahrenheit) minTemperatureFahrenheit = r.minTemperatureFahrenheit;
    if (r.maxTemperatureFahrenheit > maxTemperatureFahrenheit) maxTemperatureFahrenheit = r.maxTemperatureFahrenheit;
    if (r.percentChanceOfRain > percentChanceOfRain) percentChanceOfRain = r.percentChanceOfRain;
    if (r.percentHumidity > percentHumidity) percentHumidity = r.percentHumidity;
  }

  Map toJson() {
    return {
      'dt': dt.toString(),
      'temperatureFahrenheit': temperatureFahrenheit,
      'minTemperatureFahrenheit': minTemperatureFahrenheit,
      'maxTemperatureFahrenheit': maxTemperatureFahrenheit,
      'weatherCondition': weatherCondition.name,
      'percentChanceOfRain': percentChanceOfRain,
      'percentHumidity': percentHumidity,
    };
  }

  void fromJson(dynamic jsonObject) {
    dt = DateTime.parse(jsonObject['dt']);
    temperatureFahrenheit = jsonObject['temperatureFahrenheit'];
    minTemperatureFahrenheit = jsonObject['minTemperatureFahrenheit'];
    maxTemperatureFahrenheit = jsonObject['maxTemperatureFahrenheit'];
    weatherCondition = WeatherCondition.values.byName(jsonObject['weatherCondition']);
    percentChanceOfRain = jsonObject['percentChanceOfRain'];
    percentHumidity = jsonObject['percentHumidity'];
  }

  String getDisplayTemperatureFahrenheit() {
    return '${temperatureFahrenheit.round().toString()}\u00B0';
  }

  String getDisplayMinTemperatureFahrenheit() {
    return '${minTemperatureFahrenheit.round().toString()}\u00B0';
  }

  String getDisplayMaxTemperatureFahrenheit() {
    return '${maxTemperatureFahrenheit.round().toString()}\u00B0';
  }

  String getDisplayDate() {
    DateTime localDate = dt.toLocal();
    // print('${localDate.toString()} utc: ${localDate.isUtc}');
    // print('${dt.toString()} utc: ${dt.isUtc}');
    return DateFormat().format(localDate);
  }

  String getDisplayShortDate() {
    DateTime localDate = dt.toLocal();
    // print('${localDate.toString()} utc: ${localDate.isUtc}');
    // print('${dt.toString()} utc: ${dt.isUtc}');
    return DateFormat('EEE, MMM d').format(localDate);
  }

  String getDisplayForecastDate() {
    return DateFormat().format(dt.toLocal());
  }

  String getDisplayForecastShortDate() {
    return DateFormat('EEE, MMM d').format(dt.toLocal());
  }

  String getDisplayPercentChanceOfRain() {
    return '${percentChanceOfRain.toStringAsFixed(1)}%\u{1F4A7}';
  }

  String getDisplayPercentHumidity() {
    return '${percentHumidity.toStringAsFixed(1)}%';
  }

  String getDisplayGraphic() {
    if (percentChanceOfRain > 30.0) {
      if (weatherCondition == WeatherCondition.thunderstorm) return '\u{1F329}';
      return '\u{1F327}';
    }

    switch (weatherCondition) {
      case WeatherCondition.thunderstorm:
        return '\u{1F329}';

      case WeatherCondition.drizzle:
        return '\u{1F326}';

      case WeatherCondition.rain:
        return '\u{1F327}';

      case WeatherCondition.snow:
        return '\u{1F328}';

      case WeatherCondition.mist:
        return '\u{1F326}';

      case WeatherCondition.smoke:
        return '\u{1F32B}';

      case WeatherCondition.haze:
        return '\u{1F32B}';

      case WeatherCondition.dust:
        return '\u{1F32B}';

      case WeatherCondition.fog:
        return '\u{1F32B}';

      case WeatherCondition.sand:
        return '\u{1F32B}';

      case WeatherCondition.ash:
        return '\u{1F32B}';

      case WeatherCondition.squall:
        return '\u{1F326}';

      case WeatherCondition.tornado:
        return '\u{1F32A}';

      case WeatherCondition.clear:
        return '\u2600';

      case WeatherCondition.clouds:
        return '\u2601';

      default:
        // empty
        break;
    }

    Logger.print('warning: unknown weather condition, no graphic available');

    return '';
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class WeatherInfo {
  String city = "";
  String state = "";
  String country = "";

  double longitude = 0.0;
  double latitude = 0.0;

  // these must be sorted from the present to the future
  List<WeatherReport> reports = [];

  // these will be sorted from the present to the future after calling updateDailyInfo
  List<WeatherReport> _days = [];

  DateTime _lastApiCallDT = DateTime.utc(2000);
  bool _lastApiCallSet = false;

  bool _error = false;

  WeatherInfo({this.city = '', this.state = '', this.country = ''});

  Future<void> updateWorldLocation(WorldLocation worldLocation) async {}

  Future<void> updateNamedLocation(String city, String state, String country) async {}

  bool isValid() {
    return (reports.isNotEmpty && _days.isNotEmpty);
  }

  bool isError() {
    return _error;
  }

  void setError(bool v) {
    _error = v;
  }

  static WeatherInfo createWeatherInfo() {
    // TODO: use an app setting to choose the provider
    return OpenWeatherMap();
  }

  Map toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
      'reports': reports.map((i) => i.toJson()).toList(),
      '_days': _days.map((i) => i.toJson()).toList(),
      '_lastApiCallDT': _lastApiCallDT.toString(),
      '_lastApiCallSet': _lastApiCallSet,
    };
  }

  void fromJson(dynamic jsonObject) {
    city = jsonObject['city'];
    state = jsonObject['state'];
    country = jsonObject['country'];
    longitude = jsonObject['longitude'];
    latitude = jsonObject['latitude'];

    reports = [];
    jsonObject['reports'].forEach((i) {
      reports.add(WeatherReport.fromJson(i));
    });

    _days = [];
    jsonObject['_days'].forEach((i) {
      _days.add(WeatherReport.fromJson(i));
    });

    _lastApiCallDT = DateTime.parse(jsonObject['_lastApiCallDT']);
    _lastApiCallSet = jsonObject['_lastApiCallSet'];
  }

  Future<bool> save(String destFilePath) async {
    try {
      File dest = File(destFilePath);
      await dest.writeAsString(convert.jsonEncode(toJson()), flush: true);
    } catch (e) {
      Logger.print('failed to save weather info to \'$destFilePath\' | exception: \'${e.toString()}\'');
      return false;
    }

    Logger.print('saved weather info to \'$destFilePath\'');
    return true;
  }

  Future<bool> load(String sourceFilePath) async {
    try {
      File source = File(sourceFilePath);
      String jsonContent = await source.readAsString();
      Logger.print('read weather info from \'$sourceFilePath\' | content:\n$jsonContent\n');
      fromJson(convert.jsonDecode(jsonContent));
    } catch (e) {
      Logger.print('failed to load weather info from \'$sourceFilePath\' | exception: \'${e.toString()}\'');
      return false;
    }

    Logger.print('loaded weather info from \'$sourceFilePath\'');
    return true;
  }

  String getServiceProviderDisplayName() {
    return '';
  }

  String getLogDescription() {
    String report = '';

    try {
      report += 'city: $city, country: $country, coords: < $longitude, $latitude >\n';

      if (reports.isNotEmpty) {
        int total = reports.length;
        report += 'reports ($total):\n';
        for (int i = 0; i < total; ++i) {
          report += '  ${reports[i].getLogDescription()}\n';
        }
      }

      if (_days.isNotEmpty) {
        int total = _days.length;
        report += 'days ($total):\n';
        for (int i = 0; i < total; ++i) {
          report += '  ${_days[i].getLogDescription()}\n';
        }
      }
    } catch (e) {
      report = 'corrupt weather info';
    }

    return report;
  }

  void log() {
    Logger.print(getLogDescription());
  }

  void updateDailyInfo() {
    _days = [];

    int totalReports = reports.length;

    if (totalReports <= 0) return;

    WeatherReport currentDay = WeatherReport.clone(reports[0]);

    Map<WeatherCondition, int> weatherConditionTracker = {};
    weatherConditionTracker[currentDay.weatherCondition] = 1;

    for (int reportIndex = 1; reportIndex < totalReports; ++reportIndex) {
      WeatherReport weatherReport = reports[reportIndex];

      if (weatherReport.dt.year == currentDay.dt.year &&
          weatherReport.dt.month == currentDay.dt.month &&
          weatherReport.dt.day == currentDay.dt.day) {
        currentDay.updateDay(weatherReport);
        if (weatherConditionTracker.containsKey(weatherReport.weatherCondition))
          weatherConditionTracker[weatherReport.weatherCondition] =
              weatherConditionTracker[weatherReport.weatherCondition]! + 1;
        else
          weatherConditionTracker[weatherReport.weatherCondition] = 1;
      } else {
        int bestCount = 0;
        WeatherCondition bestCondition = WeatherCondition.unknown;

        weatherConditionTracker.forEach((k, v) {
          if (v > bestCount) {
            bestCount = v;
            bestCondition = k;
          }
        });

        currentDay.weatherCondition = bestCondition;

        _days.add(currentDay);

        currentDay = WeatherReport.clone(weatherReport);

        weatherConditionTracker.clear();
        weatherConditionTracker[currentDay.weatherCondition] = 1;
      }
    }

    int bestCount = 0;
    WeatherCondition bestCondition = WeatherCondition.unknown;

    weatherConditionTracker.forEach((k, v) {
      if (v > bestCount) {
        bestCount = v;
        bestCondition = k;
      }
    });

    currentDay.weatherCondition = bestCondition;

    _days.add(currentDay);
  }

  // returns -1 if unavailable
  int getLastApiCallElapsedMS() {
    if (!_lastApiCallSet) return -1;

    DateTime currentDT = DateTime.now().toUtc();
    Duration elapsed = currentDT.difference(_lastApiCallDT);
    return elapsed.inMilliseconds;
  }

  bool isLastApiCallExpired() {
    return false;
  }

  void setLastApiCallNow() {
    _lastApiCallDT = DateTime.now().toUtc();
    _lastApiCallSet = true;
  }

  String getLocationCaption() {
    if (state.isNotEmpty) return '$city, $state';
    return '$city, $country';
  }

  WeatherReport? getToday() {
    if (_days.isNotEmpty) return _days[0];
    return null;
  }

  String getCurrentTemperatureFahrenheit() {
    if (_days.isNotEmpty) return _days[0].getDisplayTemperatureFahrenheit();
    return "";
  }

  String getCurrentMinTemperatureFahrenheit() {
    if (_days.isNotEmpty) return _days[0].getDisplayMinTemperatureFahrenheit();
    return "";
  }

  String getCurrentMaxTemperatureFahrenheit() {
    if (_days.isNotEmpty) return _days[0].getDisplayMaxTemperatureFahrenheit();
    return "";
  }

  String getCurrentDisplayDate() {
    if (_days.isNotEmpty) return _days[0].getDisplayDate();
    return "";
  }

  String getCurrentDisplayGraphic() {
    if (_days.isNotEmpty) return _days[0].getDisplayGraphic();
    return "";
  }

  String getCurrentPercentHumidity() {
    if (_days.isNotEmpty && _days[0].percentHumidity >= 0.0) {
      return _days[0].getDisplayPercentHumidity();
    }

    return "";
  }

  List<WeatherReport> getForecast() {
    DateTime today = DateTime.now();

    List<WeatherReport> forecast = [];

    Duration adjustTime = Duration(hours: 0);

    if (_days.length > 1) {
      if (_days[1].dt.toLocal().day == today.day) {
        adjustTime = Duration(hours: 24);
      }
    }

    for (int i = 1; i < _days.length; ++i) {
      WeatherReport rpt = WeatherReport.clone(_days[i]);
      rpt.dt = rpt.dt.add(adjustTime);
      forecast.add(rpt);
    }

    return forecast;
  }
}

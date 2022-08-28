import 'package:flutter/material.dart';
import 'dart:io';

import '../devtools/logger.dart';

import '../utilities/settings_manager.dart';
import '../utilities/app_info.dart';
import '../utilities/named_location.dart';
import '../utilities/world_location.dart';

import '../weather/weather_manager.dart';
import '../weather/weather_info.dart';

import '../controls/weather_card.dart';
import '../controls/screen_frame.dart';

import 'settings_screen.dart';
import 'progress_screen.dart';
import 'message_screen.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const Color kMaxTemperatureColor = Color(0xffe77f7f);
const Color kMinTemperatureColor = Color(0xff729ee7);

const TextStyle kCaptionCardTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
  color: Color(0xFFFFFFFF),
);

const TextStyle kCaptionCardSymbolStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.normal,
  color: Color(0xFFFFFFFF),
);

const Icon kWorldLocationIcon = Icon(
  Icons.my_location_outlined,
  size: 20.0,
  color: Color(0xff6b6b6b),
);

const Icon kNamedLocationIcon = Icon(
  Icons.place,
  size: 20.0,
  color: Color(0xff6b6b6b),
);

const TextStyle kWeatherLocationStyle = TextStyle(
  fontSize: 26.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherErrorLocationStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
);

const TextStyle kWeatherCurrentTemperatureStyle = TextStyle(
  fontSize: 54.0,
  fontWeight: FontWeight.w900,
);

const TextStyle kWeatherCurrentTemperatureRangeMaxStyle = TextStyle(
  fontSize: 27.0,
  fontWeight: FontWeight.normal,
  color: kMaxTemperatureColor,
);

const TextStyle kWeatherCurrentTemperatureRangeMinStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
  color: kMinTemperatureColor,
);

const TextStyle kWeatherCurrentDateStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherCurrentGraphicStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherCurrentHumidityLabelStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherCurrentHumidityValueStyle = TextStyle(
  fontSize: 26.0,
  fontWeight: FontWeight.w900,
);

const TextStyle kWeatherForecastTemperatureStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w900,
);

const TextStyle kWeatherForecastTemperatureMaxRangeStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  color: kMaxTemperatureColor,
);

const TextStyle kWeatherForecastTemperatureMinRangeStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
  color: kMinTemperatureColor,
);

const TextStyle kWeatherForecastDateStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherForecastPercentChanceOfRainStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherForecastGraphicStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherProviderLabelStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kWeatherProviderNameStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w900,
);

const double kSingleWeatherInfoScreenVerticalMargin = 20.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

class SingleWeatherInfoScreen extends StatefulWidget {
  SingleWeatherInfoScreen({Key? key}) : super(key: key);

  @override
  State<SingleWeatherInfoScreen> createState() => _SingleWeatherInfoScreenState();
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _SingleWeatherInfoScreenState extends State<SingleWeatherInfoScreen> {
  WeatherInfo weatherInfo = WeatherInfo();

  @override
  void initState() {
    super.initState();

    SettingsManager.setup().then((v) {
      AppInfo.setup().then((v) {
        WeatherManager.updateWeatherInfo().then((v) {
          setState(() {
            weatherInfo = WeatherManager.getWeatherInfo();
            // Logger.print('retrieved weather info in initState of State<SingleWeatherInfoScreen>');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!(weatherInfo.isValid())) {
      return Scaffold(
        backgroundColor: kProgressScreenBackgroundColor,
        body: ScreenFrame(
          child: Center(
            child: AppProgressIndicator(
              text: 'retrieving weather data ...',
            ),
          ),
        ),
      );
    }

    if (weatherInfo.isError()) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: ScreenFrame(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
                buildCaptionCard(),
                const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
                Container(
                  child: WeatherCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'failed to retrieve weather info',
                            style: kWeatherErrorLocationStyle,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: buildSettingsButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ScreenFrame(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
              buildCaptionCard(),
              const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
              Container(
                child: WeatherCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            (SettingsManager.getUseCurrentLocation()) ? kWorldLocationIcon : kNamedLocationIcon,
                            const SizedBox(width: 7.0),
                            Text(
                              weatherInfo.getLocationCaption(),
                              style: kWeatherLocationStyle,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: buildSettingsButton(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
              Container(
                child: WeatherCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        weatherInfo.getCurrentTemperatureFahrenheit(),
                        style: kWeatherCurrentTemperatureStyle,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                weatherInfo.getCurrentMaxTemperatureFahrenheit(),
                                style: kWeatherCurrentTemperatureRangeMaxStyle,
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                weatherInfo.getCurrentMinTemperatureFahrenheit(),
                                style: kWeatherCurrentTemperatureRangeMinStyle,
                              ),
                            ],
                          ),
                          Text(
                            weatherInfo.getCurrentDisplayDate(),
                            style: kWeatherCurrentDateStyle,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        weatherInfo.getCurrentDisplayGraphic(),
                        style: kWeatherCurrentGraphicStyle,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
              Container(
                child: WeatherCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'humidity',
                        style: kWeatherCurrentHumidityLabelStyle,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        weatherInfo.getCurrentPercentHumidity(),
                        style: kWeatherCurrentHumidityValueStyle,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
              Container(
                child: WeatherCard(
                  child: Column(
                    children: [
                      for (WeatherReport weatherReport in weatherInfo.getForecast())
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10, height: 40),
                            Expanded(
                              flex: 2,
                              child: Text(
                                weatherReport.getDisplayForecastShortDate(),
                                style: kWeatherForecastDateStyle,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                weatherReport.getDisplayMaxTemperatureFahrenheit(),
                                style: kWeatherForecastTemperatureMaxRangeStyle,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              flex: 1,
                              child: Text(
                                weatherReport.getDisplayMinTemperatureFahrenheit(),
                                style: kWeatherForecastTemperatureMinRangeStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
                              child: Text(
                                weatherReport.getDisplayPercentChanceOfRain(),
                                style: kWeatherForecastPercentChanceOfRainStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                weatherReport.getDisplayGraphic(),
                                style: kWeatherForecastGraphicStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kSingleWeatherInfoScreenVerticalMargin),
              Container(
                child: WeatherCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'weather data provided by ',
                        style: kWeatherProviderLabelStyle,
                      ),
                      Text(
                        weatherInfo.getServiceProviderDisplayName(),
                        style: kWeatherProviderNameStyle,
                      ),
                      const SizedBox(width: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCaptionCard() {
    return WeatherCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'weather',
            style: kCaptionCardTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 10.0, height: 40.0),
          Text(
            '\u{1F310}',
            style: kCaptionCardSymbolStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 10.0),
          Text(
            'sphere',
            style: kCaptionCardTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void onSettingsButtonPressed() async {
    if (mounted) {
      setState(() {
        weatherInfo = WeatherInfo();
      });

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );

      WeatherManager.updateWeatherInfo().then((v) {
        SettingsManager.save().then((v) {
          setState(() {
            weatherInfo = WeatherManager.getWeatherInfo();
          });
        });
      });
    }
  }

  void devOnSettingsButtonPressed() async {
    MessageScreen w = MessageScreen(context, (MessageScreen messageScreen) {
      messageScreen.hide();
    });

    w.show('Testing Message Screen', 'OK');
  }

  Widget buildSettingsButton() {
    return GestureDetector(
      onTap: onSettingsButtonPressed,
      child: const Icon(
        Icons.settings,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }
}

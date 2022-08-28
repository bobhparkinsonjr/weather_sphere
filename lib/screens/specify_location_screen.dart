import 'package:flutter/material.dart';
import 'package:weather_sphere/utilities/named_location.dart';

import '../devtools/logger.dart';

import '../controls/screen_frame.dart';
import '../controls/app_text_field.dart';
import '../controls/app_button.dart';

import '../utilities/settings_manager.dart';

import '../weather/weather_info.dart';

import 'progress_screen.dart';
import 'message_screen.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const double kFormControlsVerticalMargin = 20.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

class SpecifyLocationScreen extends StatefulWidget {
  const SpecifyLocationScreen({Key? key}) : super(key: key);

  @override
  State<SpecifyLocationScreen> createState() => _SpecifyLocationScreenState();
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _SpecifyLocationScreenState extends State<SpecifyLocationScreen> {
  String _city = '';
  String _state = '';
  String _country = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xC01D1E33),
        title: const Text('Specify Location'),
      ),
      body: ScreenFrame(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kFormControlsVerticalMargin),
                AppTextField(
                  focus: true,
                  placeholder: 'city',
                  onAppTextFieldChanged: (value) {
                    _city = value;
                    // TODO: show closest matches in locations collection
                  },
                  onAppTextFieldSubmitted: (value) {
                    submitCity(value);
                  },
                ),
                const SizedBox(height: kFormControlsVerticalMargin),
                AppTextField(
                  focus: true,
                  placeholder: 'state',
                  onAppTextFieldChanged: (value) {
                    _state = value;
                    // TODO: show closest matches in locations collection
                  },
                  onAppTextFieldSubmitted: (value) {
                    submitState(value);
                  },
                ),
                const SizedBox(height: kFormControlsVerticalMargin),
                AppTextField(
                  focus: true,
                  placeholder: 'country',
                  onAppTextFieldChanged: (value) {
                    _country = value;
                    // TODO: show closest matches in locations collection
                  },
                  onAppTextFieldSubmitted: (value) {
                    submitCountry(value);
                  },
                ),
                const SizedBox(height: kFormControlsVerticalMargin),
                const SizedBox(height: kFormControlsVerticalMargin),
                const SizedBox(height: kFormControlsVerticalMargin),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      caption: 'Add Location',
                      onPress: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        submitLocation(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitLocation(BuildContext context) async {
    _city = _city.trim();
    _state = _state.trim();
    _country = _country.trim();

    String fullLocation = '';

    if (_city.isNotEmpty) fullLocation = _city;

    if (_state.isNotEmpty) {
      if (fullLocation.isNotEmpty) fullLocation += ', ';
      fullLocation += _state;
    }

    if (_country.isNotEmpty) {
      if (fullLocation.isNotEmpty) fullLocation += ', ';
      fullLocation += _country;
    }

    Logger.print('user entered full location: $fullLocation');

    ProgressScreen progressScreen = ProgressScreen(context);
    progressScreen.show('checking location ...');

    NamedLocation namedLocation = NamedLocation(city: _city, state: _state, country: _country);

    WeatherInfo weatherInfo = await namedLocation.updateWeatherInfo();
    weatherInfo.log();

    // KEEP: can use this for testing
    // await Future.delayed(const Duration(seconds: 10));

    progressScreen.hide();

    if (weatherInfo.isValid() && !(weatherInfo.isError())) {
      SettingsManager.mergeLocation(namedLocation, select: true);
      SettingsManager.setUseCurrentLocation(false);
      if (mounted) Navigator.of(context).pop();
    } else {
      if (mounted) {
        MessageScreen w = MessageScreen(context, (MessageScreen messageScreen) {
          messageScreen.hide();
        });

        w.show('Failed to retrieve info for location $fullLocation', 'OK');
      }
    }
  }

  void submitCity(String city) {
    // Logger.print('user entered city: $city');
  }

  void submitState(String state) {
    // Logger.print('user entered state: $state');
  }

  void submitCountry(String country) {
    // Logger.print('user entered country: $country');
  }
}

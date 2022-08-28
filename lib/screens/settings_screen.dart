import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../devtools/logger.dart';

import '../utilities/settings_manager.dart';
import '../utilities/app_info.dart';

import '../controls/settings_button.dart';
import '../controls/settings_divider.dart';
import '../controls/settings_info.dart';
import '../controls/screen_frame.dart';

import 'choose_box_fit_screen.dart';
import 'choose_alignment_screen.dart';
import 'specify_location_screen.dart';
import 'locations_screen.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xC01D1E33),
        title: const Text('Settings'),
      ),
      body: ScreenFrame(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SettingsDivider(),
                SettingsButton(
                  caption: 'Use Current Location',
                  description: 'Use location services to determine the current location.',
                  selected: SettingsManager.getUseCurrentLocation(),
                  onPress: () {
                    if (SettingsManager.getUseCurrentLocation()) {
                      if (SettingsManager.hasLocationInfo()) {
                        setState(() {
                          SettingsManager.setUseCurrentLocation(false);
                        });
                      }
                    } else {
                      setState(() {
                        SettingsManager.setUseCurrentLocation(true);
                      });
                    }
                  },
                ),
                SettingsButton(
                  caption: 'Specify Location',
                  description: (SettingsManager.hasLocationInfo() && !(SettingsManager.getUseCurrentLocation()))
                      ? SettingsManager.getDisplayFullLocation()
                      : 'Enter a city, state, and country.',
                  selected: !(SettingsManager.getUseCurrentLocation()),
                  onPress: () async {
                    if (SettingsManager.hasLocationInfo()) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationsScreen(),
                        ),
                      );
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecifyLocationScreen(),
                        ),
                      );
                    }
                    setState(() {});
                  },
                ),
                const SettingsDivider(),
                SettingsButton(
                  caption: 'Set Background Image',
                  description: 'Choose a background image to display on all screens.',
                  onPress: () async {
                    if (await Permission.storage.request().isGranted) {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        String backgroundImageFilePath = result.files.single.path!;

                        setState(() {
                          SettingsManager.setBackgroundImageFilePath(backgroundImageFilePath);
                        });

                        // Logger.print('user chose image: $backgroundImageFilePath');
                      } else {
                        // User canceled the picker
                      }
                    }
                  },
                ),
                SettingsButton(
                  caption: 'Clear Background Image',
                  description: 'Remove the background image.',
                  onPress: () {
                    setState(() {
                      SettingsManager.setBackgroundImageFilePath('');
                    });
                  },
                ),
                SettingsButton(
                  caption: 'Background Image Fit',
                  description: 'Adjust the fit of the background image.',
                  currentValue: ChooseBoxFitScreen.getBoxFitCaption(SettingsManager.getBackgroundImageBoxFit()),
                  onPress: () async {
                    Object? chosenFit = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseBoxFitScreen(
                          caption: 'Background Image Fit',
                          selectedBoxFit: SettingsManager.getBackgroundImageBoxFit(),
                        ),
                      ),
                    );

                    setState(() {
                      if (chosenFit != null) {
                        SettingsManager.setBackgroundImageBoxFit(chosenFit as BoxFit);
                      }
                    });
                  },
                ),
                SettingsButton(
                  caption: 'Background Image Origin',
                  description: 'Change the origin of the background image.',
                  currentValue: ChooseAlignmentScreen.getAlignmentCaption(SettingsManager.getBackgroundImageAlignment()),
                  onPress: () async {
                    Object? chosenAlignment = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseAlignmentScreen(
                          caption: 'Background Image Alignment',
                          selectedAlignment: SettingsManager.getBackgroundImageAlignment(),
                        ),
                      ),
                    );

                    setState(() {
                      if (chosenAlignment != null) {
                        SettingsManager.setBackgroundImageAlignment(chosenAlignment as Alignment);
                      }
                    });
                  },
                ),
                const SettingsDivider(),
                SettingsInfo(
                  label: 'version',
                  value: AppInfo.getDisplayVersion(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

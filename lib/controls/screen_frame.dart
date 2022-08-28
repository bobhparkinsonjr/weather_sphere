import 'package:flutter/material.dart';
import 'dart:io';
import '../utilities/settings_manager.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (SettingsManager.getBackgroundImageFilePath().isNotEmpty)
          ? BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(
                    // TODO: what happens if the image no longer exists?
                    SettingsManager.getBackgroundImageFilePath(),
                  ),
                ),
                fit: SettingsManager.getBackgroundImageBoxFit(),
                alignment: SettingsManager.getBackgroundImageAlignment(),
              ),
            )
          : BoxDecoration(
              color: SettingsManager.getBackgroundFillColor(),
            ),
      child: child,
    );
  }
}

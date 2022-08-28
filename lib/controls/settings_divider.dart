import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const BoxDecoration kSettingsDividerDecoration = BoxDecoration(
  color: Color(0xC01D1E33),
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.black,
    ),
  ),
);

const double kSettingsDividerPaddingVertical = 14.0;
const double kSettingsDividerPaddingHorizontal = 24.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSettingsDividerPaddingVertical,
        horizontal: kSettingsDividerPaddingHorizontal,
      ),
      decoration: kSettingsDividerDecoration,
    );
  }
}

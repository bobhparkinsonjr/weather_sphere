import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const BoxDecoration kSettingsInfoDecoration = BoxDecoration(
  color: Color(0xC01D1E33),
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.black,
    ),
  ),
);

const double kSettingsInfoPaddingVertical = 10.0;
const double kSettingsInfoPaddingHorizontal = 24.0;

const TextStyle kSettingsInfoLabelStyle = TextStyle(
  fontSize: 12.0,
  fontStyle: FontStyle.italic,
  color: Color(0xffb4b4b4),
);

const TextStyle kSettingsInfoValueStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
  color: Color(0xffdbdbdb),
);

///////////////////////////////////////////////////////////////////////////////////////////////////

class SettingsInfo extends StatelessWidget {
  final String label;
  final String value;

  const SettingsInfo({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSettingsInfoPaddingVertical,
        horizontal: kSettingsInfoPaddingHorizontal,
      ),
      decoration: kSettingsInfoDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            label,
            style: kSettingsInfoLabelStyle,
          ),
          const SizedBox(width: 6.0),
          Text(
            value,
            style: kSettingsInfoValueStyle,
          ),
        ],
      ),
    );
  }
}

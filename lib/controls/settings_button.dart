import 'package:flutter/material.dart';
import 'app_colors.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

typedef SettingsButtonPressedCallback = void Function();

const BoxDecoration kSettingsButtonDecoration = BoxDecoration(
  color: Color(0xC01D1E33),
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.black,
    ),
  ),
);

const BoxDecoration kSelectedSettingsButtonDecoration = BoxDecoration(
  color: kAppColorPrimarySelected,
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.black,
    ),
  ),
);

const TextStyle kSettingsButtonCaptionTextStyle = TextStyle(
  color: Color(0xffdbdbdb),
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
);

const TextStyle kSettingsButtonDescriptionTextStyle = TextStyle(
  color: Color(0xffb4b4b4),
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kSettingsButtonCurrentValueTextStyle = TextStyle(
  color: kAppColorSecondarySelected,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
);

const double kSettingsButtonPaddingVertical = 14.0;
const double kSettingsButtonPaddingHorizontal = 24.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

class SettingsButton extends StatelessWidget {
  const SettingsButton(
      {Key? key,
      this.child,
      this.onPress,
      required this.caption,
      required this.description,
      this.selected = false,
      this.currentValue = ''})
      : super(key: key);

  final Widget? child;
  final SettingsButtonPressedCallback? onPress;
  final String caption;
  final String description;
  final bool selected;
  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kSettingsButtonPaddingVertical,
          horizontal: kSettingsButtonPaddingHorizontal,
        ),
        decoration: selected ? kSelectedSettingsButtonDecoration : kSettingsButtonDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  caption,
                  style: kSettingsButtonCaptionTextStyle,
                ),
                const SizedBox(width: 10.0),
                Text(
                  currentValue,
                  style: kSettingsButtonCurrentValueTextStyle,
                ),
              ],
            ),
            Text(
              description,
              style: kSettingsButtonDescriptionTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

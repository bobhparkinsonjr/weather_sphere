import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

typedef AppButtonPressedCallback = void Function();

const Color kAppButtonForegroundColor = Color(0xFFA1B3E7);

const TextStyle kAppButtonCaptionTextStyle = TextStyle(
  fontSize: 20.0,
  color: kAppButtonForegroundColor,
);

const Color kAppButtonBackgroundColor = Color(0xC01D1E33);
const Color kAppButtonBorderColor = kAppButtonForegroundColor;
const double kAppButtonBorderRadius = 26.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

class AppButton extends StatelessWidget {
  const AppButton({Key? key, this.onPress, required this.caption}) : super(key: key);

  final AppButtonPressedCallback? onPress;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: kAppButtonBackgroundColor,
          borderRadius: BorderRadius.circular(kAppButtonBorderRadius),
          border: Border.all(color: kAppButtonBorderColor),
        ),
        child: Center(
          child: Text(
            caption,
            style: kAppButtonCaptionTextStyle,
          ),
        ),
      ),
    );
  }
}

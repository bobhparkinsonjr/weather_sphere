import 'package:flutter/material.dart';

const Color kWeatherCardColor = Color(0xC01D1E33);

typedef WeatherCardPressedCallback = void Function();

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key, this.child, this.onPress}) : super(key: key);

  final Widget? child;
  final WeatherCardPressedCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: kWeatherCardColor,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: kWeatherCardColor),
        ),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

// import 'dev_screen.dart';
import 'single_weather_info_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SingleWeatherInfoScreen(),
    );
  }
}

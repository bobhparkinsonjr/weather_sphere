import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const Color kProgressScreenBackgroundColor = Color(0xC0000000);
const Color kProgressScreenForegroundColor = Color(0xFFFFFFFF);

const TextStyle kProgressScreenTextStyle = TextStyle(
  color: kProgressScreenForegroundColor,
  fontSize: 14,
);

///////////////////////////////////////////////////////////////////////////////////////////////////

class ProgressScreen {
  ProgressScreen(this.context);

  final BuildContext context;
  bool displayed = false;

  void show(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: kProgressScreenBackgroundColor,
      builder: (BuildContext context) {
        displayed = true;
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            elevation: 0.0,
            contentPadding: const EdgeInsets.all(0.0),
            insetPadding: const EdgeInsets.all(0.0),
            /*
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  8.0,
                ),
              ),
            ),
            */
            backgroundColor: const Color(0x41000000),
            content: AppProgressIndicator(text: message),
          ),
        );
      },
    );
  }

  void hide() {
    if (displayed) {
      Navigator.of(context).pop();
      displayed = false;
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key, this.text = ''}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(0.0),
      color: const Color(0x9A000000),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getLoadingIndicator(),
          _getText(),
        ],
      ),
    );
  }

  Padding _getLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: 32,
        height: 32,
        color: const Color(0x00000000),
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          color: kProgressScreenForegroundColor,
        ),
      ),
    );
  }

  Text _getText() {
    return Text(
      text,
      style: kProgressScreenTextStyle,
      textAlign: TextAlign.center,
    );
  }
}

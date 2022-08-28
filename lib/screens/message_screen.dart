import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

typedef MessageScreenClosedCallback = void Function(MessageScreen messageScreen);

const Color kMessageScreenBarrierColor = Color(0x9A000000);
const Color kMessageScreenBackgroundColor = Color(0xC01D1E33);
const Color kMessageScreenForegroundColor = Color(0xFFCECECE);

const TextStyle kMessageScreenMessageTextStyle = TextStyle(
  color: kMessageScreenForegroundColor,
  fontSize: 18,
);

const TextStyle kMessageScreenButtonTextStyle = TextStyle(
  color: Color(0xFF598ED8),
  fontSize: 16,
);

const BoxDecoration kMessageScreenDividerDecoration = BoxDecoration(
  color: Color(0xFF5D5D5D),
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: kMessageScreenForegroundColor,
    ),
  ),
);

///////////////////////////////////////////////////////////////////////////////////////////////////

class MessageScreen {
  MessageScreen(this.context, this.onPress);

  final BuildContext context;
  bool displayed = false;
  final MessageScreenClosedCallback onPress;

  void show(String message, String buttonCaption) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: kMessageScreenBarrierColor,
      builder: (BuildContext context) {
        displayed = true;
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            elevation: 1.0,
            insetPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            contentPadding: const EdgeInsets.all(0.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  26.0,
                ),
              ),
            ),
            backgroundColor: kMessageScreenBackgroundColor,
            content: Container(
              padding: const EdgeInsets.all(0.0),
              margin: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    child: Text(
                      message,
                      style: kMessageScreenMessageTextStyle,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    margin: const EdgeInsets.all(0.0),
                    decoration: kMessageScreenDividerDecoration,
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      onPress(this);
                    },
                    child: Text(
                      buttonCaption,
                      style: kMessageScreenButtonTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
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

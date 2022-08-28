import 'package:flutter/material.dart';
import '../controls/screen_frame.dart';
import '../controls/settings_button.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class BoxFitInfo {
  final String caption;
  final String description;
  final BoxFit boxFit;

  const BoxFitInfo({required this.caption, required this.description, required this.boxFit});
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class ChooseBoxFitScreen extends StatefulWidget {
  const ChooseBoxFitScreen({Key? key, required this.caption, required this.selectedBoxFit}) : super(key: key);

  final String caption;
  final BoxFit selectedBoxFit;

  static const List<BoxFitInfo> _boxFits = [
    BoxFitInfo(
      caption: 'Contain',
      description: 'As large as possible while still containing the source entirely within the target box.',
      boxFit: BoxFit.contain,
    ),
    BoxFitInfo(
      caption: 'Cover',
      description: 'As small as possible while still covering the entire target box.',
      boxFit: BoxFit.cover,
    ),
    BoxFitInfo(
      caption: 'Fill',
      description: 'Fill the target box by distorting the source\'s aspect ratio.',
      boxFit: BoxFit.fill,
    ),
    BoxFitInfo(
      caption: 'Fit Height',
      description:
          'Make sure the full height of the source is shown, regardless of whether this means the source overflows the target box horizontally.',
      boxFit: BoxFit.fitHeight,
    ),
    BoxFitInfo(
      caption: 'Fit Width',
      description:
          'Make sure the full width of the source is shown, regardless of whether this means the source overflows the target box vertically.',
      boxFit: BoxFit.fitWidth,
    ),
    BoxFitInfo(
      caption: 'Scale Down',
      description:
          'Align the source within the target box (by default, centering) and, if necessary, scale the source down to ensure that the source fits within the box.',
      boxFit: BoxFit.scaleDown,
    ),
  ];

  @override
  State<ChooseBoxFitScreen> createState() => _ChooseBoxFitScreenState();

  static String getBoxFitCaption(BoxFit boxFit) {
    for (BoxFitInfo info in _boxFits) {
      if (info.boxFit == boxFit) return info.caption;
    }
    return '';
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _ChooseBoxFitScreenState extends State<ChooseBoxFitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xC01D1E33),
        title: Text(widget.caption),
      ),
      body: ScreenFrame(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (BoxFitInfo info in ChooseBoxFitScreen._boxFits)
              SettingsButton(
                caption: info.caption,
                description: info.description,
                selected: (info.boxFit == widget.selectedBoxFit),
                onPress: () {
                  Navigator.pop(
                    context,
                    info.boxFit,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

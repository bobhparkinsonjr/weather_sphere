import 'package:flutter/material.dart';
import '../controls/screen_frame.dart';
import '../controls/settings_button.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class AlignmentInfo {
  final String caption;
  final String description;
  final Alignment alignment;

  const AlignmentInfo({required this.caption, required this.description, required this.alignment});
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class ChooseAlignmentScreen extends StatefulWidget {
  const ChooseAlignmentScreen({Key? key, required this.caption, required this.selectedAlignment}) : super(key: key);

  final String caption;
  final Alignment selectedAlignment;

  static final List<AlignmentInfo> _alignments = [
    const AlignmentInfo(
      caption: 'Bottom Center',
      description: 'Select the bottom center of the image as the origin.',
      alignment: Alignment.bottomCenter,
    ),
    const AlignmentInfo(
      caption: 'Bottom Left',
      description: 'Select the bottom left of the image as the origin.',
      alignment: Alignment.bottomLeft,
    ),
    const AlignmentInfo(
      caption: 'Bottom Right',
      description: 'Select the bottom right of the image as the origin.',
      alignment: Alignment.bottomRight,
    ),
    const AlignmentInfo(
      caption: 'Center',
      description: 'Select the center of the image as the origin.',
      alignment: Alignment.center,
    ),
    const AlignmentInfo(
      caption: 'Center Left',
      description: 'Select the center left of the image as the origin.',
      alignment: Alignment.centerLeft,
    ),
    const AlignmentInfo(
      caption: 'Center Right',
      description: 'Select the center right of the image as the origin.',
      alignment: Alignment.centerRight,
    ),
    const AlignmentInfo(
      caption: 'Top Center',
      description: 'Select the top center of the image as the origin.',
      alignment: Alignment.topCenter,
    ),
    const AlignmentInfo(
      caption: 'Top Left',
      description: 'Select the top left of the image as the origin.',
      alignment: Alignment.topLeft,
    ),
    const AlignmentInfo(
      caption: 'Top Right',
      description: 'Select the top right of the image as the origin.',
      alignment: Alignment.topRight,
    ),
    const AlignmentInfo(
      caption: 'Top Left 1/2',
      description: 'Select the top left 1/2 of the image as the origin.',
      alignment: Alignment(-0.5, -0.5),
    ),
    const AlignmentInfo(
      caption: 'Top Right 1/2',
      description: 'Select the top right 1/2 of the image as the origin.',
      alignment: Alignment(0.5, -0.5),
    ),
    const AlignmentInfo(
      caption: 'Bottom Left 1/2',
      description: 'Select the bottom left 1/2 of the image as the origin.',
      alignment: Alignment(-0.5, 0.5),
    ),
    const AlignmentInfo(
      caption: 'Bottom Right 1/2',
      description: 'Select the bottom right 1/2 of the image as the origin.',
      alignment: Alignment(0.5, 0.5),
    ),
  ];

  @override
  State<ChooseAlignmentScreen> createState() => _ChooseAlignmentScreenState();

  static String getAlignmentCaption(Alignment alignment) {
    for (AlignmentInfo info in _alignments) {
      if (info.alignment == alignment) return info.caption;
    }
    return '';
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _ChooseAlignmentScreenState extends State<ChooseAlignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xC01D1E33),
        title: Text(widget.caption),
      ),
      body: ScreenFrame(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (AlignmentInfo info in ChooseAlignmentScreen._alignments)
                SettingsButton(
                  caption: info.caption,
                  description: info.description,
                  selected: (info.alignment == widget.selectedAlignment),
                  onPress: () {
                    Navigator.pop(
                      context,
                      info.alignment,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

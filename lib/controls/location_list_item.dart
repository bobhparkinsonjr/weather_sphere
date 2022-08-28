import 'package:flutter/material.dart';

import '../utilities/named_location.dart';

import '../controls/app_colors.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const BoxDecoration kLocationListItemDecoration = BoxDecoration(
  color: Color(0xC01D1E33),
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.black,
    ),
  ),
);

const BoxDecoration kSelectedLocationListItemDecoration = BoxDecoration(
  color: kAppColorPrimarySelected,
  border: Border(
    bottom: BorderSide(
      width: 1,
      color: Colors.black,
    ),
  ),
);

const TextStyle kLocationListItemNormalTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
);

const TextStyle kLocationListItemSelectedTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.normal,
);

const double kLocationListItemPaddingVertical = 14.0;
const double kLocationListItemPaddingHorizontal = 24.0;

typedef LocationListItemPressedCallback = void Function(int index);

///////////////////////////////////////////////////////////////////////////////////////////////////

class LocationListItem extends StatelessWidget {
  const LocationListItem(
      {Key? key, required this.index, required this.namedLocation, required this.selected, required this.onPress})
      : super(key: key);

  final int index;
  final NamedLocation namedLocation;
  final bool selected;
  final LocationListItemPressedCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress(index);
      },
      child: Container(
        height: 60.0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          vertical: kLocationListItemPaddingVertical,
          horizontal: kLocationListItemPaddingHorizontal,
        ),
        decoration: selected ? kSelectedLocationListItemDecoration : kLocationListItemDecoration,
        child: Text(
          namedLocation.getDisplayFullLocation(),
          style: selected ? kLocationListItemSelectedTextStyle : kLocationListItemNormalTextStyle,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

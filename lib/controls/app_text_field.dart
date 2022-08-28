import 'package:flutter/material.dart';
import 'app_colors.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const Color kAppTextFieldForegroundColor = Color(0xffdbdbdb);
const Color kAppTextFieldFillColor = Color(0xB3000000);

const TextStyle kAppTextFieldTextStyle = TextStyle(
  fontSize: 20.0,
  color: kAppTextFieldForegroundColor,
  fontStyle: FontStyle.normal,
);

const BorderSide kAppTextFieldBorderStyle = BorderSide(
  color: kAppTextFieldForegroundColor,
  width: 1.0,
  style: BorderStyle.solid,
);

const BorderSide kAppTextFieldFocusBorderStyle = BorderSide(
  color: kAppColorSecondarySelected,
  width: 2.0,
  style: BorderStyle.solid,
);

const BorderRadius kAppTextFieldBorderRadius = BorderRadius.all(Radius.circular(30.0));

const TextStyle kAppTextFieldPlaceholderTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xFF797979),
);

typedef OnAppTextFieldChanged = void Function(String text);
typedef OnAppTextFieldSubmitted = void Function(String text);

///////////////////////////////////////////////////////////////////////////////////////////////////

class AppTextField extends StatefulWidget {
  const AppTextField(
      {Key? key,
      this.focus = false,
      this.placeholder = '',
      this.autocorrect = true,
      this.onAppTextFieldChanged,
      this.onAppTextFieldSubmitted})
      : super(key: key);

  final bool focus;
  final String placeholder;
  final bool autocorrect;
  final OnAppTextFieldChanged? onAppTextFieldChanged;
  final OnAppTextFieldSubmitted? onAppTextFieldSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      if (widget.onAppTextFieldChanged != null) widget.onAppTextFieldChanged!(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autofocus: widget.focus,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      autocorrect: widget.autocorrect,
      style: kAppTextFieldTextStyle,
      cursorColor: kAppColorSecondarySelected,
      onSubmitted: (value) {
        if (widget.onAppTextFieldSubmitted != null) widget.onAppTextFieldSubmitted!(value);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 2.0),
        filled: true,
        fillColor: kAppTextFieldFillColor,
        hintText: widget.placeholder,
        hintStyle: kAppTextFieldPlaceholderTextStyle,
        border: const OutlineInputBorder(
          borderSide: kAppTextFieldBorderStyle,
          borderRadius: kAppTextFieldBorderRadius,
          gapPadding: 0.0,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: kAppTextFieldFocusBorderStyle,
          borderRadius: kAppTextFieldBorderRadius,
          gapPadding: 0.0,
        ),
        suffixIcon: IconButton(
          color: kAppTextFieldForegroundColor,
          focusColor: kAppColorSecondarySelected,
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          onPressed: () {
            _textController.clear();
          },
          icon: Container(
            // decoration: BoxDecoration( shape: BoxShape.circle, color: Theme.of( context ).primaryColor ),
            child: const Icon(
              Icons.clear,
            ),
          ),
        ),
      ),
    );
  }
}

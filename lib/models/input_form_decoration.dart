import 'package:flutter/material.dart';

/// The decoration for form inputs
class InputFormDecoration {
  InputFormDecoration({
    this.borderColor = Colors.grey,
    this.selectedBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.grey,
    this.selectedIconColor = Colors.grey,
    this.buttonBackgroundColor = Colors.blue,
    this.hintColor = Colors.grey,
    this.nullErrorText,
    this.titleStyle,
    this.hintStyle,
    this.textStyle,
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(4);

  final Color backgroundColor;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color errorBorderColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color buttonBackgroundColor;
  final Color hintColor;
  final BorderRadius borderRadius;
  final String? nullErrorText;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
}

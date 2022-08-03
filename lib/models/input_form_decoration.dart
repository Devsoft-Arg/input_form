import 'package:flutter/material.dart';

/// The decoration for form inputs
class InputFormDecoration {
  InputFormDecoration({
    this.borderColor = Colors.grey,
    this.selectedBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.iconColor = Colors.grey,
    this.selectedIconColor = Colors.grey,
    this.buttonBackgroundColor = Colors.blue,
    this.hintColor = Colors.grey,
    this.backgroundColor,
    this.nullErrorText,
    this.notValidErrorText,
    this.titleStyle,
    this.hintStyle,
    this.textStyle,
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(4);

  final Color borderColor;
  final Color selectedBorderColor;
  final Color errorBorderColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color buttonBackgroundColor;
  final Color hintColor;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final String? nullErrorText;
  final String? notValidErrorText;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
}

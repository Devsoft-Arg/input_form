import 'package:flutter/material.dart';

/// The decoration for form inputs
class InputFormDecorationData {
  InputFormDecorationData({
    this.nullErrorText,
    this.notValidErrorText,
    this.inputPadding = EdgeInsets.zero,
    this.style,
  });

  final String? nullErrorText;
  final String? notValidErrorText;
  final EdgeInsets inputPadding;
  final TextStyle? style;
}

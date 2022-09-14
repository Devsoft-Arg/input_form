import 'package:flutter/material.dart';

/// The decoration for form inputs
class InputFormDecoration {
  InputFormDecoration({
    this.nullErrorText,
    this.notValidErrorText,
    this.inputPadding = EdgeInsets.zero,
  });

  final String? nullErrorText;
  final String? notValidErrorText;
  final EdgeInsets inputPadding;
}

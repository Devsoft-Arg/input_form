import 'package:flutter/material.dart';

import '../models/models.dart';

class InputFormDecoration extends InheritedWidget {
  const InputFormDecoration({
    super.key,
    required this.data,
    required super.child,
  });

  final InputFormDecorationData data;

  static InputFormDecorationData of(BuildContext context) {
    final InputFormDecoration? result =
        context.dependOnInheritedWidgetOfExactType<InputFormDecoration>();
    assert(result != null, 'No InputFormDecorationData found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(InputFormDecoration oldWidget) =>
      data != oldWidget.data;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/input_provider.dart';

/// Text button for [InputForm].
///
/// When pressed returns the form input data.
class TextFormButton extends StatelessWidget {
  const TextFormButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.enabled = true,
  }) : super(key: key);

  /// Button text
  final String text;

  /// Function that is activated when the button is tapped.
  ///
  /// The function return the data entered in the form inputs.
  final Function(Map<String, dynamic> values) onTap;

  /// Set the button as enabled
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final inputProvider = context.read<InputProvider>();
    return TextButton(
      onPressed: enabled
          ? () {
              final values = inputProvider.validateAndGetData();
              if (values != null) {
                onTap(values);
              }
            }
          : null,
      child: Text(text),
    );
  }
}

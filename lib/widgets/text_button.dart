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
  }) : super(key: key);

  /// Button text
  final String text;

  /// Function that is activated when the button is tapped.
  ///
  /// The function return the data entered in the form inputs.
  final Function(Map<String, dynamic> values) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputProvider = context.read<InputProvider>();
    final decoration = inputProvider.decoration;
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => decoration.buttonBackgroundColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: decoration.borderRadius,
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(const Size.fromHeight(55)),
      ),
      onPressed: () {
        final values = inputProvider.validateAndGetData();
        if (values != null) {
          onTap(values);
        }
      },
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}

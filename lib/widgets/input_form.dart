import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/input_form_decoration.dart';
import '../providers/input_provider.dart';

/// Form that must be above the input fields
class InputForm extends StatelessWidget {
  InputForm({
    Key? key,
    this.data,
    required this.child,
    required this.decoration,
  }) : super(key: key);

  /// Widget child.
  final Widget child;

  /// The decoration for form inputs.
  final InputFormDecoration decoration;

  /// Initial data that is passed to the input fields.
  final Map<String, dynamic>? data;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ChangeNotifierProvider(
        create: (_) => InputProvider(
          formKey: formKey,
          data: data ?? {},
          decoration: decoration,
        ),
        child: child,
      ),
    );
  }
}

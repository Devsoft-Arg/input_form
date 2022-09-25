import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/input_provider.dart';

/// Form that must be above the input fields
class InputForm extends StatelessWidget {
  const InputForm({
    required this.child,
    this.data,
    super.key,
  });

  /// Widget child.
  final Widget child;

  /// Initial data that is passed to the input fields.
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: ChangeNotifierProvider(
        create: (_) => InputProvider(
          formKey: formKey,
          data: data ?? {},
        ),
        child: child,
      ),
    );
  }
}

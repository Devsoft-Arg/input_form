import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';

/// Input field for time
class TimeInputField extends StatefulWidget {
  const TimeInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    this.initialTime,
    this.nullable = false,
    this.showIfAnd,
    this.showIfOr,
  })  : assert(
          showIfAnd == null || showIfOr == null,
          'Passing nullableIfAnd and nullableIfOr at the same time is not allowed.',
        ),
        super(key: key);

  /// Name of the value in the map returned in [TextFormButton].
  final String name;

  /// Title text of widget.
  final String title;

  /// Hint text of widget.
  final String hint;

  /// Leading icon of widget.
  final IconData icon;

  /// Initial time of time picker
  final TimeOfDay? initialTime;

  /// Allows the entered text to be null or empty.
  ///
  /// By default is false.
  final bool nullable;

  /// Check the conditions contained in the list with 'and'
  /// to show or not the widget.
  final List<Condition>? showIfAnd;

  /// Check the conditions contained in the list with 'or'
  /// to show or not the widget.
  final List<Condition>? showIfOr;

  @override
  State<TimeInputField> createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  TimeOfDay? time;
  late InputProvider inputProvider;

  @override
  void didChangeDependencies() {
    inputProvider = Provider.of<InputProvider>(context);
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      time = initialValue;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = Provider.of<InputProvider>(context);
    final decoration = inputProvider.decoration;

    return InputField<TimeOfDay>(
      name: widget.name,
      title: widget.title,
      hint: widget.hint,
      prefixIcon: Icon(widget.icon),
      onTap: _onTap,
      validator: (text) => _validator(text, decoration.nullErrorText),
      toStringValue: (time) => time.format(context),
    );
  }

  String? _validator(_, String? nullErrorText) {
    if (widget.nullable) return null;

    if (time == null) return nullErrorText;

    return null;
  }

  Future<void> _onTap(dynamic setValue) async {
    TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: widget.initialTime ?? TimeOfDay.now(),
    );

    if (result != null) {
      if (mounted) FocusScope.of(context).nextFocus();

      time = result;
      setValue(time);
    }
  }
}

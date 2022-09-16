import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';

/// Input field for date
class DateInputField extends StatefulWidget {
  const DateInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.dateFormat,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
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

  /// Set a format for the date text
  final DateFormat dateFormat;

  /// First day of calendar picker
  final DateTime firstDate;

  /// Last day of calendar picker
  final DateTime lastDate;

  /// Selected day of calendar picker
  final DateTime? initialDate;

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
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  DateTime? date;
  late InputProvider inputProvider;

  @override
  void didChangeDependencies() {
    inputProvider = Provider.of<InputProvider>(context);
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      date = initialValue;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = inputProvider.decoration;

    return InputField<DateTime>(
      name: widget.name,
      title: widget.title,
      hint: widget.hint,
      prefixIcon: Icon(widget.icon),
      onTap: (setValue) => _onTap(setValue),
      toStringValue: (value) => widget.dateFormat.format(value),
      validator: (text) => _validator(text, decoration.nullErrorText),
    );
  }

  String? _validator(_, String? nullErrorText) {
    if (widget.nullable) return null;

    if (date == null) return nullErrorText;

    return null;
  }

  Future<void> _onTap(SetValueType setValue) async {
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (result != null) {
      if (mounted) FocusScope.of(context).nextFocus();

      date = result;
      setValue(date);
    }
  }
}

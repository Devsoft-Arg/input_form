import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';

/// Input field for files
class CheckboxInputField extends StatefulWidget {
  const CheckboxInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.icon,
    this.hint,
    this.selectedHint,
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

  /// Leading icon of widget.
  final IconData icon;

  /// Hint text of widget.
  final String? hint;

  /// Function that returns hint text.
  ///
  /// Shown if status is true;
  final String? selectedHint;

  /// Check the conditions contained in the list with 'and'
  /// to show or not the widget.
  final List<Condition>? showIfAnd;

  /// Check the conditions contained in the list with 'or'
  /// to show or not the widget.
  final List<Condition>? showIfOr;

  @override
  State<CheckboxInputField> createState() => _CheckboxInputFieldState();
}

class _CheckboxInputFieldState extends State<CheckboxInputField> {
  bool state = false;
  late InputProvider inputProvider;

  @override
  void didChangeDependencies() {
    inputProvider = Provider.of<InputProvider>(context);
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      state = initialValue;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = Provider.of<InputProvider>(context);
    final key = GlobalKey<InputFieldState>();

    return InputField<bool>(
      key: key,
      hint: '',
      name: widget.name,
      title: widget.title,
      toStringValue: (value) =>
          (value ? widget.hint : widget.selectedHint) ?? widget.title,
      onTap: _onTap,
      showFloatingLabel: widget.hint != null,
      prefixIcon: Icon(widget.icon),
      suffixIcon: Checkbox(
        onChanged: (value) {
          inputProvider.setData(widget.name, value);
        },
        value: state,
      ),
    );
  }

  Future<void> _onTap(SetValueType setValue) async {
    state = !state;
    setValue(state);
  }
}

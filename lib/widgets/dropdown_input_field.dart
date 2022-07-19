import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:input_form/utils/input_decoration.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';
import 'title_form.dart';

/// Dropdown input field with options
class DropdownInputField extends StatefulWidget {
  const DropdownInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.values,
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

  /// Values to be show as options in the dropdown list.
  final List<String> values;

  /// Allows that it is not necessary to select any [values].
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
  State<DropdownInputField> createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputProvider = context.read<InputProvider>();
    final decoration = inputProvider.decoration;

    if (widget.showIfAnd != null) {
      final data = context.select<InputProvider, bool>(
          (state) => canShowAnd(state.data, widget.showIfAnd!));

      if (!data) {
        return const SizedBox.shrink();
      }
    }

    if (widget.showIfOr != null) {
      final data = context.select<InputProvider, bool>(
          (state) => canShowOr(state.data, widget.showIfOr!));

      if (!data) {
        return const SizedBox.shrink();
      }
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DropdownButtonFormField<String>(
            alignment: Alignment.bottomCenter,
            value: value,
            style: decoration.textStyle ?? theme.textTheme.titleMedium,
            decoration: getInputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.icon,
              theme: theme,
              decoration: decoration,
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 14),
            ),
            validator: (text) => _validator(text, inputProvider),
            onChanged: (String? value) => _onChanged(value, inputProvider),
            items: widget.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        TitleForm(widget.title),
      ],
    );
  }

  void _onChanged(String? newValue, InputProvider inputProvider) {
    FocusScope.of(context).nextFocus();
    setState(() {
      value = newValue!;
      inputProvider.setData(widget.name, value);
    });
  }

  String? _validator(String? text, InputProvider inputProvider) {
    if (widget.nullable) return null;

    if (text == null || text == '') {
      return inputProvider.decoration.nullErrorText;
    }

    return null;
  }
}

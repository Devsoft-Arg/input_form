import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:input_form/utils/input_decoration.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';
import 'custom_dropdown_button.dart' as cs;
import 'title_form.dart';

/// Dropdown input field with options
class DropdownInputField<T> extends StatefulWidget {
  const DropdownInputField({
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.values,
    this.nullable = false,
    this.showIfAnd,
    this.showIfOr,
    super.key,
  })  : assert(
          showIfAnd == null || showIfOr == null,
          'Passing nullableIfAnd and nullableIfOr at the same time is not allowed.',
        ),
        assert(
          T == String || T == int || T == double,
          'Passing types other than String, int, or double is not allowed.',
        );

  /// Name of the value in the map returned in [TextFormButton].
  final String name;

  /// Title text of widget.
  final String title;

  /// Hint text of widget.
  final String hint;

  /// Leading icon of widget.
  final IconData icon;

  /// Values to be show as options in the dropdown list.
  final List<DropdownItem<T>> values;

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
  State<DropdownInputField> createState() => _DropdownInputFieldState<T>();
}

class _DropdownInputFieldState<T> extends State<DropdownInputField> {
  T? value;

  @override
  void didChangeDependencies() {
    final data = context.read<InputProvider>().data;
    final initialValue = data[widget.name];
    final values = widget.values.map((e) => e.key);
    if (values.contains(initialValue)) {
      value = initialValue;
    }
    super.didChangeDependencies();
  }

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
    return Padding(
      padding: decoration.inputPadding,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: cs.CustomDropdownButtonFormField<T>(
              borderRadius: decoration.borderRadius,
              value: value,
              style: decoration.textStyle ?? theme.textTheme.titleMedium,
              decoration: getInputDecoration(
                hintText: widget.hint,
                prefixIcon: widget.icon,
                theme: theme,
                decoration: decoration,
                padding: const EdgeInsets.fromLTRB(12, 22, 12, 14),
              ),
              validator: (T? text) => _validator(text, inputProvider),
              onChanged: (T? value) => _onChanged(value, inputProvider),
              items: widget.values.map<cs.DropdownMenuItem<T>>((item) {
                return cs.DropdownMenuItem<T>(
                  value: item.key,
                  child: Text(item.value),
                );
              }).toList(),
            ),
          ),
          TitleForm(widget.title),
        ],
      ),
    );
  }

  void _onChanged(T? newValue, InputProvider inputProvider) {
    FocusScope.of(context).nextFocus();
    setState(() {
      value = newValue;
      inputProvider.setData(widget.name, value);
    });
  }

  String? _validator(T? text, InputProvider inputProvider) {
    if (widget.nullable) return null;

    if (text == null || text == '') {
      return inputProvider.decoration.nullErrorText;
    }

    return null;
  }
}

class DropdownItem<T> {
  final T key;
  final String value;

  DropdownItem(this.key, this.value);
}

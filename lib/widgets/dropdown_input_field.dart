import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';
import 'custom_dropdown_button.dart' as cs;

const _outlineDefaultPadding = EdgeInsets.fromLTRB(12, 20, 12, 20);
const _underlineDefaultPadding = EdgeInsets.fromLTRB(12, 12, 12, 12);

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
  late InputProvider inputProvider;
  T? value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    inputProvider = context.read<InputProvider>();
    final initialValue = inputProvider.data[widget.name];
    final values = widget.values.map((e) => e.key);
    if (values.contains(initialValue)) {
      value = initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = InputFormDecoration.of(context);
    final inputDecorationTheme = theme.inputDecorationTheme;
    final contentPadding = inputDecorationTheme.contentPadding ??
        (inputDecorationTheme.border != null
            ? (inputDecorationTheme.border!.isOutline
                ? _outlineDefaultPadding
                : _underlineDefaultPadding)
            : null);

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
      child: cs.CustomDropdownButtonFormField<T>(
        borderRadius: inputDecorationTheme.border?.isOutline ?? false
            ? (inputDecorationTheme.border as OutlineInputBorder).borderRadius
            : (inputDecorationTheme.border as UnderlineInputBorder)
                .borderRadius,
        value: value,
        isExpanded: true,
        decoration: const InputDecoration()
            .applyDefaults(inputDecorationTheme)
            .copyWith(
              contentPadding: contentPadding?.subtract(
                const EdgeInsets.symmetric(vertical: 2.5),
              ),
              labelText: widget.title,
              hintText: widget.hint,
              prefixIcon: Icon(widget.icon),
            ),
        alignment: Alignment.topCenter,
        validator: (T? text) => _validator(text, decoration),
        onChanged: (T? value) => _onChanged(value, inputProvider),
        style: decoration.style,
        items: widget.values.map<cs.DropdownMenuItem<T>>((item) {
          return cs.DropdownMenuItem<T>(
            value: item.key,
            child: Text(item.value),
          );
        }).toList(),
      ),
    );
  }

  void _onChanged(T? newValue, InputProvider inputProvider) {
    FocusScope.of(context).nextFocus();
    value = newValue;
    inputProvider.setData(widget.name, value);
  }

  String? _validator(T? text, InputFormDecorationData decoration) {
    if (widget.nullable) return null;

    if (text == null || text == '') {
      return decoration.nullErrorText;
    }

    return null;
  }
}

class DropdownItem<T> {
  final T key;
  final String value;

  DropdownItem(this.key, this.value);
}

import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';

typedef SetValueType<T> = void Function(T? value);

/// Input field for date
class InputField<T> extends StatefulWidget {
  const InputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.prefixIcon,
    required this.onTap,
    this.suffixIcon,
    this.validator,
    this.toStringValue,
    this.nullable = false,
    this.writable = false,
    this.showIfAnd,
    this.showIfOr,
    this.showFloatingLabel = true,
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

  /// Prefix icon of widget.
  final Widget prefixIcon;

  /// Suffix icon of widget.
  final Widget? suffixIcon;

  /// Validator function that receives the entered text and allows
  /// an error to be returned.
  ///
  /// If it returns null, it is ignored.
  final String? Function(String? text)? validator;

  /// Validator function that receives value and to string
  ///
  /// If it returns null, it is ignored.
  final String Function(T value)? toStringValue;

  /// Value set function that receives a new value and
  /// displays it in the input field
  final Function(SetValueType setValue) onTap;

  /// Allows the entered text to be null or empty.
  ///
  /// By default is false.
  final bool nullable;

  /// Allows to write text
  ///
  /// By default is false.
  final bool writable;

  /// Check the conditions contained in the list with 'and'
  /// to show or not the widget.
  final List<Condition>? showIfAnd;

  /// Check the conditions contained in the list with 'or'
  /// to show or not the widget.
  final List<Condition>? showIfOr;

  /// Allows the floating tag to be displayed.
  final bool showFloatingLabel;

  @override
  State<InputField<T>> createState() => InputFieldState<T>();
}

class InputFieldState<T> extends State<InputField<T>> {
  late final TextEditingController controller;
  late InputProvider inputProvider;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    inputProvider = context.read<InputProvider>();
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      controller.text =
          widget.toStringValue?.call(initialValue) ?? '$initialValue';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = InputFormDecoration.of(context);
    final inputDecorationTheme = theme.inputDecorationTheme;

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
      child: TextFormField(
        controller: controller,
        readOnly: !widget.writable,
        validator: widget.validator,
        onTap: () => widget.onTap(setValue as SetValueType),
        style: decoration.style,
        decoration: const InputDecoration()
            .applyDefaults(inputDecorationTheme)
            .copyWith(
              labelText: widget.title,
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              floatingLabelBehavior: !widget.showFloatingLabel
                  ? FloatingLabelBehavior.never
                  : null,
            ),
      ),
    );
  }

  void setValue(T? value) {
    controller.text =
        value != null ? widget.toStringValue?.call(value) ?? '$value' : '';
    inputProvider.setData(widget.name, value);
  }
}

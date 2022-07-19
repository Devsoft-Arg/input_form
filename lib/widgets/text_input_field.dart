import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';
import '../utils/input_decoration.dart';
import 'title_form.dart';

/// Input field for text
class TextInputField extends StatefulWidget {
  const TextInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    this.type = TextInputType.text,
    this.nullable = false,
    this.validator,
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

  /// Text input type of widget.
  final TextInputType type;

  /// Validator function that receives the entered text and allows
  /// an error to be returned.
  ///
  /// If it returns non-null text, [InputFormDecoration.nullErrorText]
  /// will be show as an error.
  ///
  /// If it returns null, it is ignored.
  final String? Function(String text)? validator;

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
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool hidden = true;

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

    return Theme(
      data: theme.copyWith(
        primaryColor: decoration.selectedIconColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              style: decoration.textStyle ?? theme.textTheme.titleMedium,
              obscureText:
                  hidden && widget.type == TextInputType.visiblePassword,
              keyboardType: widget.type,
              textInputAction: getTextInputAction(widget.type),
              textCapitalization: getTextCapitalization(widget.type),
              minLines: 1,
              maxLines: 10,
              validator: (text) => _validator(text, decoration.nullErrorText),
              onChanged: (text) => inputProvider.setData(widget.name, text),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              decoration: getInputDecoration(
                hintText: widget.hint,
                prefixIcon: widget.icon,
                theme: theme,
                decoration: decoration,
              ),
            ),
          ),
          TitleForm(widget.title),
        ],
      ),
    );
  }

  String? _validator(String? text, String? nullErrorText) {
    if (widget.nullable) return null;

    if (text == null || text == '') return nullErrorText;

    final validator = widget.validator?.call(text);
    if (validator != null) return validator;

    return null;
  }

  TextCapitalization getTextCapitalization(TextInputType type) {
    if (type == TextInputType.name || type == TextInputType.streetAddress) {
      return TextCapitalization.words;
    } else if (type == TextInputType.multiline || type == TextInputType.text) {
      return TextCapitalization.sentences;
    }
    return TextCapitalization.sentences;
  }

  TextInputAction? getTextInputAction(TextInputType type) {
    if (widget.type == TextInputType.multiline) {
      return null;
    } else {
      return TextInputAction.next;
    }
  }
}

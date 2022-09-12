import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';
import 'title_form.dart';

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

  @override
  void initState() {
    final inputProvider = context.read<InputProvider>();
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      time = inputProvider.data[widget.name];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputProvider = Provider.of<InputProvider>(context);
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
      child: FormField(
        validator: (text) => _validator(text, decoration.nullErrorText),
        builder: (state) => Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 59,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: decoration.backgroundColor ??
                        theme.scaffoldBackgroundColor,
                    border: Border.all(
                      color: state.hasError
                          ? decoration.errorBorderColor
                          : decoration.borderColor,
                      width: 2,
                    ),
                    borderRadius: decoration.borderRadius,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          _onTap(inputProvider, FocusScope.of(context)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: Icon(
                                widget.icon,
                                color: decoration.iconColor,
                              ),
                            ),
                          ),
                          if (time == null)
                            Text(
                              widget.hint,
                              style: decoration.hintStyle ??
                                  theme.textTheme.titleMedium?.copyWith(
                                    color: decoration.hintColor,
                                  ),
                            )
                          else
                            Text(
                              time!.format(context),
                              style: decoration.textStyle ??
                                  theme.textTheme.titleMedium,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                TitleForm(widget.title),
              ],
            ),
            if (state.hasError)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 13),
                  child: Text(
                    state.errorText!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: decoration.errorBorderColor,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  String? _validator(_, String? nullErrorText) {
    if (widget.nullable) return null;

    if (time == null) return nullErrorText;

    return null;
  }

  Future<void> _onTap(
    InputProvider inputProvider,
    FocusScopeNode focusScope,
  ) async {
    TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: widget.initialTime ?? TimeOfDay.now(),
    );

    if (result != null) {
      time = result;
      inputProvider.setData(widget.name, time);

      setState(() {});
    }
  }
}

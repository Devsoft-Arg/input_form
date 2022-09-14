import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';

/// Input field for date
class DateInputFieldE extends StatefulWidget {
  const DateInputFieldE({
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
  State<DateInputFieldE> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputFieldE> {
  DateTime? date;
  late final TextEditingController controller;

  @override
  void initState() {
    final inputProvider = context.read<InputProvider>();
    final initialValue = inputProvider.data[widget.name];
    controller = TextEditingController();

    if (initialValue != null) {
      date = inputProvider.data[widget.name];
      controller.text = inputProvider.data[widget.name];
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

    final inputDecorationTheme = theme.inputDecorationTheme;

    return Padding(
      padding: decoration.inputPadding,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (text) => _validator(text, decoration.nullErrorText),
        onTap: () => _onTap(inputProvider, FocusScope.of(context)),
        decoration: const InputDecoration()
            .applyDefaults(inputDecorationTheme)
            .copyWith(
              hintText: widget.hint,
              prefixIcon: Icon(widget.icon),
            ),
      ),
    );
  }

  String? _validator(_, String? nullErrorText) {
    if (widget.nullable) return null;

    if (date == null) return nullErrorText;

    return null;
  }

  Future<void> _onTap(
    InputProvider inputProvider,
    FocusScopeNode focusScope,
  ) async {
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (result != null) {
      date = result;
      inputProvider.setData(widget.name, date);
      controller.text = widget.dateFormat.format(date!);

      setState(() {});
    }
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';
import '../utils/can_show.dart';
import 'title_form.dart';

/// Input field for files
class FileInputField extends StatefulWidget {
  const FileInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.selectedHint,
    this.minFiles = 1,
    this.allowedExtensions,
    this.showIfAnd,
    this.showIfOr,
    this.minFilesErrorText,
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

  /// Function that returns hint text.
  ///
  /// Shown if there is at least one image selected.
  final String Function(int imagesQuantity) selectedHint;

  /// Minimum number of images.
  ///
  /// If the number of selected images is less than [minFiles],
  /// [minFilesErrorText] will be show.
  final int minFiles;

  /// Allowed file extensions.
  final List<String>? allowedExtensions;

  /// Check the conditions contained in the list with 'and'
  /// to show or not the widget.
  final List<Condition>? showIfAnd;

  /// Check the conditions contained in the list with 'or'
  /// to show or not the widget.
  final List<Condition>? showIfOr;

  /// Text to be show as an error if the number of
  /// selected images is less than [minFiles].
  final String? minFilesErrorText;

  @override
  State<FileInputField> createState() => _FileInputFieldState();
}

class _FileInputFieldState extends State<FileInputField> {
  final selectedFiles = <String>[];

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

    return FormField(
      validator: (text) => _validator(text, decoration.nullErrorText),
      builder: (state) => Column(
        children: [
          Stack(
            children: [
              Container(
                height: 59,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: decoration.backgroundColor,
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
                    onTap: () => _onTap(inputProvider, FocusScope.of(context)),
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
                        if (selectedFiles.isEmpty)
                          Text(
                            widget.hint,
                            style: decoration.hintStyle ??
                                theme.textTheme.titleMedium?.copyWith(
                                  color: decoration.hintColor,
                                ),
                          )
                        else
                          Text(
                            widget.selectedHint(selectedFiles.length),
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
    );
  }

  String? _validator(_, String? nullErrorText) {
    if (widget.minFiles == 0) return null;

    if (selectedFiles.isEmpty) {
      return nullErrorText;
    }

    if (selectedFiles.length < widget.minFiles) {
      return widget.minFilesErrorText;
    }
    return null;
  }

  Future<void> _onTap(
    InputProvider inputProvider,
    FocusScopeNode focusScope,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: widget.allowedExtensions,
      allowMultiple: true,
    );

    if (result != null) {
      selectedFiles.clear();
      selectedFiles.addAll(
        [for (final path in result.paths) path!],
      );
      inputProvider.setData(widget.name, selectedFiles);

      focusScope.nextFocus();
      setState(() {});
    }
  }
}

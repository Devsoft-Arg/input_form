import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';

import '../models/condition.dart';

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
  List<String> selectedFiles = <String>[];
  late InputProvider inputProvider;

  @override
  void didChangeDependencies() {
    inputProvider = Provider.of<InputProvider>(context);
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      selectedFiles = initialValue;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = Provider.of<InputProvider>(context);
    final decoration = inputProvider.decoration;
    final key = GlobalKey<InputFieldState>();

    return InputField<List<String>>(
      key: key,
      validator: (text) => _validator(text, decoration.nullErrorText),
      name: widget.name,
      title: widget.title,
      hint: widget.hint,
      onTap: _onTap,
      toStringValue: (value) => widget.selectedHint(value.length),
      prefixIcon: Icon(widget.icon),
      suffixIcon: selectedFiles.isNotEmpty
          ? IconButton(
              onPressed: () {
                selectedFiles.clear();
                key.currentState!.setValue(null);
              },
              icon: const Icon(Icons.close),
            )
          : null,
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

  Future<void> _onTap(SetValueType setValue) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: widget.allowedExtensions,
      allowMultiple: true,
    );

    if (result != null) {
      selectedFiles = [for (final path in result.paths) path!];

      if (mounted) FocusScope.of(context).nextFocus();

      setValue(selectedFiles);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../models/condition.dart';

/// Input field for images
class ImageInputField extends StatefulWidget {
  const ImageInputField({
    Key? key,
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.selectedHint,
    this.minFiles = 1,
    this.maxFiles = 9,
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

  /// Maximum number of images allowed.
  final int maxFiles;

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
  State<ImageInputField> createState() => _ImageInputFieldState();
}

class _ImageInputFieldState extends State<ImageInputField> {
  List<String> selectedImages = <String>[];
  late InputProvider inputProvider;

  @override
  void didChangeDependencies() {
    inputProvider = Provider.of<InputProvider>(context);
    final initialValue = inputProvider.data[widget.name];

    if (initialValue != null) {
      selectedImages = initialValue;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = Provider.of<InputProvider>(context);
    final decoration = InputFormDecoration.of(context);
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
      suffixIcon: selectedImages.isNotEmpty
          ? IconButton(
              onPressed: () {
                selectedImages.clear();
                key.currentState!.setValue(null);
              },
              icon: const Icon(Icons.close),
            )
          : null,
    );
  }

  String? _validator(_, String? nullErrorText) {
    if (widget.minFiles == 0) return null;

    if (selectedImages.isEmpty) {
      return nullErrorText;
    }

    if (selectedImages.length < widget.minFiles) {
      return widget.minFilesErrorText;
    }
    return null;
  }

  Future<void> _onTap(SetValueType setValue) async {
    final result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: widget.maxFiles,
        filterOptions: FilterOptionGroup(),
      ),
    );

    if (result != null) {
      selectedImages = [for (final asset in result) (await asset.file)!.path];

      if (mounted) FocusScope.of(context).nextFocus();

      setValue(selectedImages);
    }
  }
}

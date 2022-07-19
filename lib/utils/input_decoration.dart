import 'package:flutter/material.dart';
import 'package:input_form/input_form.dart';

InputDecoration getInputDecoration({
  required String hintText,
  required IconData prefixIcon,
  required ThemeData theme,
  required InputFormDecoration decoration,
  EdgeInsets padding = const EdgeInsets.fromLTRB(12, 24, 12, 16),
}) {
  return InputDecoration(
    contentPadding: padding,
    hintText: hintText,
    filled: true,
    fillColor: decoration.backgroundColor,
    hintStyle: decoration.hintStyle ??
        theme.textTheme.titleMedium?.copyWith(
          color: decoration.hintColor,
        ),
    errorStyle: theme.textTheme.labelMedium?.copyWith(
      color: decoration.errorBorderColor,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: decoration.borderRadius,
      borderSide: BorderSide(color: decoration.borderColor, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: decoration.borderRadius,
      borderSide: BorderSide(color: decoration.selectedBorderColor, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: decoration.borderRadius,
      borderSide: BorderSide(color: decoration.errorBorderColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: decoration.borderRadius,
      borderSide: BorderSide(color: decoration.errorBorderColor, width: 2),
    ),
    prefixIcon: SizedBox(
      width: 50,
      child: Center(
        child: Icon(prefixIcon),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../models/input_form_decoration.dart';

class InputProvider with ChangeNotifier {
  InputProvider({
    required GlobalKey<FormState> formKey,
    required Map<String, dynamic> data,
    required InputFormDecoration decoration,
  })  : _formKey = formKey,
        _data = data,
        _decoration = decoration;

  final GlobalKey<FormState> _formKey;
  final Map<String, dynamic> _data;
  final InputFormDecoration _decoration;

  InputFormDecoration get decoration => _decoration;

  void setData(String name, dynamic value) {
    _data[name] = value;
    notifyListeners();
  }

  Map<String, dynamic> get data => _data;

  Map<String, dynamic>? validateAndGetData() {
    if (!_formKey.currentState!.validate()) return null;
    return _data;
  }
}

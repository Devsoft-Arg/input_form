import 'package:flutter/material.dart';

import '../models/input_form_decoration.dart';

class InputProvider with ChangeNotifier {
  InputProvider({
    required GlobalKey<FormState> formKey,
    required Map<String, dynamic> data,
    required InputFormDecoration decoration,
  })  : _data = data,
        _formKey = formKey,
        _decoration = decoration;

  Map<String, dynamic> _data;
  final GlobalKey<FormState> _formKey;
  final InputFormDecoration _decoration;

  InputFormDecoration get decoration => _decoration;

  void setData(String name, dynamic value) {
    _data = {
      ..._data,
      name: value,
    };

    notifyListeners();
  }

  Map<String, dynamic> get data => _data;

  Map<String, dynamic>? validateAndGetData() {
    if (!_formKey.currentState!.validate()) return null;
    return _data;
  }
}

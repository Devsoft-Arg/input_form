import 'package:flutter/material.dart';

class InputProvider with ChangeNotifier {
  InputProvider({
    required GlobalKey<FormState> formKey,
    required Map<String, dynamic> data,
  })  : _data = data,
        _formKey = formKey;

  Map<String, dynamic> _data;
  final GlobalKey<FormState> _formKey;

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

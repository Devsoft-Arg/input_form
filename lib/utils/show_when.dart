import '../models/condition.dart';

bool showWhen(Condition cond, Map<String, dynamic> data) {
  final whenCondValueIsNull = cond.value == null &&
      data[cond.key] != null &&
      data[cond.key] != '' &&
      data[cond.key] != [];

  final whenCondValueIsNotNull =
      cond.value != null && data[cond.key] == cond.value;

  return whenCondValueIsNull || whenCondValueIsNotNull;
}

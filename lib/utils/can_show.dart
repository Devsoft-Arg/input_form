import '../models/condition.dart';
import 'show_when.dart';

bool canShowAnd(Map<String, dynamic> data, List<Condition> conditions) {
  return conditions.every((cond) => showWhen(cond, data));
}

bool canShowOr(Map<String, dynamic> data, List<Condition> conditions) {
  return conditions.any((cond) => showWhen(cond, data));
}

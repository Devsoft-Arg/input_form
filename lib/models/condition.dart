class Condition {
  Condition(this.key, [this.value])
      : assert(
          value is String || value is num || value is List || value == null,
          'value parameter must be of type string, number, list or null',
        );

  final String key;
  final dynamic value;
}

class Station {
  final String code;
  final String name;
  final String hindiName;
  final String city;
  final String zone;

  const Station({
    required this.code,
    required this.name,
    required this.hindiName,
    required this.city,
    required this.zone,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Station && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

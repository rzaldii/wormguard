class ControlModel {
  final bool isAuto;
  final int updatedAt;

  ControlModel({
    required this.isAuto,
    required this.updatedAt,
  });

  factory ControlModel.fromMap(Map<dynamic, dynamic> map) {
    return ControlModel(
      isAuto: map['is_auto'] ?? true,
      updatedAt: map['updated_at'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_auto': isAuto,
      'updated_at': updatedAt,
    };
  }
}
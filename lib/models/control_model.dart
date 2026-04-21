class ControlModel {
  final bool isAuto;
  final bool pumpStatus; // true = ON

  ControlModel({required this.isAuto, required this.pumpStatus});

  factory ControlModel.fromMap(Map<String, dynamic> map) {
    return ControlModel(
      isAuto: map['is_auto'] ?? false,
      pumpStatus: map['pump_status'] == 'on',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_auto': isAuto,
      'pump_status': pumpStatus ? 'on' : 'off',
    };
  }
}
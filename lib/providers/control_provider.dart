import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/control_model.dart';

final controlProvider = StateProvider<ControlModel>((ref) {
  return ControlModel(isAuto: true, pumpStatus: false);
});
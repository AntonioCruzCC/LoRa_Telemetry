import 'package:lora_telemetry/controllers/district.dart';

class FilterHandler {
  static final FilterHandler _filterSingleton = FilterHandler._internal();

  static District? selectedDistrict;

  factory FilterHandler() {
    return _filterSingleton;
  }

  FilterHandler._internal();
}

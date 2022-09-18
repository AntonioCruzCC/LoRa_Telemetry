import 'package:lora_telemetry/controllers/district.dart';
import 'package:lora_telemetry/handlers/firestore_handler.dart';

class FilterHandler {
  static final FilterHandler _filterSingleton = FilterHandler._internal();

  static District? selectedDistrict;

  factory FilterHandler() {
    return _filterSingleton;
  }

  FilterHandler._internal() {
    FirestoreHandler().getAllDistricts().then(
          (districts) => selectedDistrict = districts[0],
        );
  }
}

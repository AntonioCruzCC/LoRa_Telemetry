import 'package:flutter/material.dart';
import 'package:lora_telemetry/controllers/district.dart';
import 'package:lora_telemetry/handlers/filter_handler.dart';
import 'package:lora_telemetry/handlers/firestore_handler.dart';

class DistrictsComboBox extends StatefulWidget {
  const DistrictsComboBox({Key? key}) : super(key: key);

  @override
  State<DistrictsComboBox> createState() => _DistrictsComboBoxState();
}

class _DistrictsComboBoxState extends State<DistrictsComboBox> {
  List<DropdownMenuItem<District>>? items;

  setItems(List<District> itemsToSet) {
    items ??= itemsToSet
        .map(
          (District district) => DropdownMenuItem<District>(
            value: district,
            child: Text(district.name),
          ),
        )
        .toList();

    if (items != null && items!.where((item) => item.value == null).isEmpty) {
      items!.insert(
        0,
        const DropdownMenuItem(
          value: null,
          child: Text('Todos'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreHandler().getAllDistricts(),
        builder: (context, AsyncSnapshot<List<District>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          setItems(snapshot.data!);
          return DropdownButton<District>(
            items: items,
            onChanged: (District? item) {
              setState(() {
                FilterHandler.selectedDistrict = item;
              });
            },
            value: FilterHandler.selectedDistrict,
            isExpanded: true,
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:lora_telemetry/handlers/filter_handler.dart';

class LimitSlider extends StatefulWidget {
  const LimitSlider({Key? key}) : super(key: key);

  @override
  State<LimitSlider> createState() => _LimitSliderState();
}

class _LimitSliderState extends State<LimitSlider> {
  String getSliderLabel() {
    return (FilterHandler.limitOfRecords ?? 10.00) < 100
        ? FilterHandler.limitOfRecords.toString()
        : 'Todos';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Limite de Medidores',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Slider(
          min: 1,
          max: 100,
          divisions: 20,
          label: getSliderLabel(),
          value: FilterHandler.limitOfRecords?.toDouble() ?? 10.0,
          onChanged: (value) {
            setState(
              () {
                FilterHandler.limitOfRecords = value.toInt();
              },
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lora_telemetry/controllers/power_meter.dart';

class PowerMeterDetails extends StatefulWidget {
  final PowerMeter powerMeter;
  const PowerMeterDetails(this.powerMeter, {Key? key}) : super(key: key);

  @override
  State<PowerMeterDetails> createState() => _PowerMeterDetailsState();
}

class _PowerMeterDetailsState extends State<PowerMeterDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Medidor: ${widget.powerMeter.id}'),
      content: Container(
        child: const Text('Informações do Medidor'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lora_telemetry/controllers/power_meter.dart';

class InstantValues extends StatelessWidget {
  final PowerMeter powerMeter;
  const InstantValues({Key? key, required this.powerMeter}) : super(key: key);

  Widget getSectionTitle(BuildContext context, String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
        title,
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Valores Instantâneos'),
      children: [
        getSectionTitle(context, 'Tensões:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VA: ${powerMeter.instantValues?.VA.toStringAsFixed(2)}'),
            Text('VB: ${powerMeter.instantValues?.VB.toStringAsFixed(2)}'),
            Text('VC: ${powerMeter.instantValues?.VC.toStringAsFixed(2)}'),
          ],
        ),
        getSectionTitle(context, 'Correntes:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('IA: ${powerMeter.instantValues?.IA.toStringAsFixed(2)}'),
            Text('IB: ${powerMeter.instantValues?.IB.toStringAsFixed(2)}'),
            Text('IC: ${powerMeter.instantValues?.IC.toStringAsFixed(2)}'),
          ],
        ),
        getSectionTitle(context, 'Potências:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('WA: ${powerMeter.instantValues?.WA.toStringAsFixed(2)}'),
            Text('WB: ${powerMeter.instantValues?.WB.toStringAsFixed(2)}'),
            Text('WC: ${powerMeter.instantValues?.WC.toStringAsFixed(2)}'),
          ],
        ),
        getSectionTitle(context, 'Temperatura e Frequência:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Temp: ${powerMeter.instantValues?.temp.toStringAsFixed(2)}'),
            Text('Freq: ${powerMeter.instantValues?.freq.toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}

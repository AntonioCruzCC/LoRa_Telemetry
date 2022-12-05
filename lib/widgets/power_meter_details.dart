import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lora_telemetry/controllers/power_meter.dart';
import 'package:lora_telemetry/handlers/file_handler.dart';
import 'package:lora_telemetry/widgets/instant_values.dart';
import 'package:open_file_plus/open_file_plus.dart';

class PowerMeterDetails extends StatefulWidget {
  final PowerMeter powerMeter;
  const PowerMeterDetails(this.powerMeter, {Key? key}) : super(key: key);

  @override
  State<PowerMeterDetails> createState() => _PowerMeterDetailsState();
}

class _PowerMeterDetailsState extends State<PowerMeterDetails> {
  final FileHandler _fileHandler = FileHandler();

  getFormattedDate(DateTime? dateTime) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm:ss');
    return (dateTime != null
        ? dateFormat.format(dateTime)
        : 'Nunca atualizado!');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medidor: ${widget.powerMeter.id}',
              maxLines: 1,
            ),
            Text(
              'Última atualização:${getFormattedDate(widget.powerMeter.lastUpdate)}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            InstantValues(
              powerMeter: widget.powerMeter,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Exportar'),
          onPressed: () async {
            File jsonFile = await _fileHandler
                .writeFile(widget.powerMeter.toJson().toString());
            await OpenFile.open(jsonFile.path);
          },
        ),
      ],
    );
  }
}

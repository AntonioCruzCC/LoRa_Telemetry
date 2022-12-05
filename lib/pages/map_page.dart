import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lora_telemetry/controllers/power_meter.dart';
import 'package:lora_telemetry/handlers/file_handler.dart';
import 'package:lora_telemetry/handlers/firestore_handler.dart';
import 'package:lora_telemetry/handlers/location_handler.dart';
import 'package:lora_telemetry/widgets/filter.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../widgets/power_meter_details.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final LocationHandler _locationHandler = LocationHandler();
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  final FileHandler _fileHandler = FileHandler();
  Set<Marker> markers = {};

  Future<String> _getMapStyle() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
  }

  Future<CameraPosition> getCameraPosition() async {
    return CameraPosition(
      target: await _locationHandler.getCurrentLocation(),
      zoom: 15,
    );
  }

  setMarkers() async {
    Stream<List<PowerMeter>> filteredMetersStream =
        _firestoreHandler.getFilteredMeters();

    await for (List<PowerMeter> powerMeters in filteredMetersStream) {
      Set<Marker> markersToSet = powerMeters
          .map(
            (PowerMeter meter) => Marker(
              markerId: MarkerId(meter.id),
              position: meter.geolocation,
              onTap: () => showDialog<String>(
                context: context,
                builder: (context) => PowerMeterDetails(
                  meter,
                ),
              ),
            ),
          )
          .toSet();
      setState(() {
        markers = markersToSet;
      });
    }
  }

  exportMarkersAsJson() async {
    Stream<List<PowerMeter>> filteredMetersStream =
        _firestoreHandler.getFilteredMeters();
    await for (List<PowerMeter> powerMeters in filteredMetersStream) {
      List<String> metersJson = powerMeters
          .map((PowerMeter meter) => meter.toJson().toString())
          .toList();
      String allMetersJson = '{[';
      for (int i = 0; i < metersJson.length; i++) {
        if (i != metersJson.length - 1) {
          allMetersJson += '${metersJson[i]},';
        } else {
          allMetersJson += metersJson[i];
        }
      }
      allMetersJson += ']}';
      File file = await _fileHandler.writeFile(allMetersJson);
      await OpenFile.open(file.path);
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    controller.setMapStyle(await _getMapStyle());
    await setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("LoRa Telemetry"),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((BuildContext context) => const Filter()),
                ).then(
                  (value) => setMarkers(),
                );
              },
              child: const Icon(Icons.filter_alt),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: (() {
                exportMarkersAsJson();
              }),
              child: const Icon(Icons.file_copy),
            )
          ],
        ),
        body: FutureBuilder<CameraPosition>(
          future: getCameraPosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition: snapshot.data!,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                markers: markers,
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ative a localização do seu dispositivo e reinicie o aplicativo!',
                ),
              );
            } else {
              return Center(
                child: LocationHandler().serviceEnabled != null &&
                        !LocationHandler().serviceEnabled!
                    ? const Text(
                        'Ative a localização do seu dispositivo e reinicie o aplicativo!',
                      )
                    : const CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

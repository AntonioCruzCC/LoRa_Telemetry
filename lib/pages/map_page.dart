import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lora_telemetry/handlers/firestore_handler.dart';
import 'package:lora_telemetry/handlers/location_handler.dart';
import 'package:lora_telemetry/widgets/filter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final LocationHandler _locationHandler = LocationHandler();
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
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

  setMarkers(BuildContext context) async {
    Set<Marker> markersToSet = await _firestoreHandler.getFilteredMeters(
      context,
    );
    setState(() {
      markers = markersToSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    setMarkers(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("LoRa Telemetry"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: ((BuildContext context) => const Filter()),
            ).then(
              (value) => setMarkers(context),
            );
          },
          child: const Icon(Icons.filter_alt),
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
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                  controller.setMapStyle(await _getMapStyle());
                },
                markers: markers,
              );
            } else {
              return Center(
                child: LocationHandler().serviceEnabled != null &&
                        !LocationHandler().serviceEnabled!
                    ? const Text(
                        'Ative a localização do seu dispositivo!',
                      )
                    : const CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

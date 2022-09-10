import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lora_telemetry/handlers/location_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final LocationHandler _locationHandler = LocationHandler();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("LoRa Telemetry")),
        body: FutureBuilder<CameraPosition>(
          future: getCameraPosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition: snapshot.data!,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                  controller.setMapStyle(await _getMapStyle());
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

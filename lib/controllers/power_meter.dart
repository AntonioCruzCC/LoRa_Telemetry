import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lora_telemetry/controllers/district.dart';
import 'package:lora_telemetry/controllers/extensions/instant_values.dart';

class PowerMeter {
  String id;
  LatLng geolocation;
  DocumentReference districtRef;
  DateTime? lastUpdate;
  InstantValues? instantValues;

  Future<District> get district async {
    return District.fromJson(
      districtRef.id,
      ((await districtRef.get()).data()! as Map<String, Object?>),
    );
  }

  PowerMeter({
    required this.id,
    required this.geolocation,
    required this.districtRef,
    this.lastUpdate,
    this.instantValues,
  });

  PowerMeter.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          geolocation: LatLng(
            (json['Geolocation']! as GeoPoint).latitude,
            (json['Geolocation']! as GeoPoint).longitude,
          ),
          districtRef: (json['District']! as DocumentReference),
          lastUpdate: json['LastUpdate'] != null
              ? (json['LastUpdate'] as Timestamp).toDate()
              : null,
          instantValues: InstantValues(json),
        );

  Map<String, Object?> toJson() {
    return {
      'Geolocation': geolocation,
      'District': districtRef,
      'LastUpdate': lastUpdate,
      'InstantValues': instantValues?.toJson().toString()
    };
  }
}

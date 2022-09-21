import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lora_telemetry/controllers/district.dart';

class PowerMeter {
  String id;
  LatLng geolocation;
  DocumentReference districtRef;
  DateTime? nextBilling;

  Future<District> get district async {
    return District.fromJson(
      districtRef.id,
      ((await districtRef.get()).data()! as Map<String, Object?>),
    );
  }

  PowerMeter(
      {required this.id,
      required this.geolocation,
      required this.districtRef,
      this.nextBilling});

  PowerMeter.fromJson(String id, Map<String, Object?> json)
      : this(
            id: id,
            geolocation: LatLng(
              (json['Geolocation']! as GeoPoint).latitude,
              (json['Geolocation']! as GeoPoint).longitude,
            ),
            districtRef: (json['District']! as DocumentReference),
            nextBilling: (json['NextBilling']! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {
      'Geolocation': geolocation,
      'District': districtRef,
      'NextBilling': nextBilling
    };
  }
}

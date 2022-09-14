import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PowerMeter {
  String id;
  LatLng position;

  PowerMeter({
    required this.id,
    required this.position,
  });

  PowerMeter.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          position: LatLng(
            (json['geolocation']! as GeoPoint).latitude,
            (json['geolocation']! as GeoPoint).longitude,
          ),
        );

  Map<String, Object?> toJson() {
    return {
      'position': position,
    };
  }
}

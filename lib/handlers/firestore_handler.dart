import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lora_telemetry/controllers/district.dart';
import 'package:lora_telemetry/controllers/power_meter.dart';
import 'package:lora_telemetry/widgets/power_meter_details.dart';

import 'filter_handler.dart';

class FirestoreHandler {
  static final FirestoreHandler _firestoreSingleton =
      FirestoreHandler._internal();

  late FirebaseFirestore db;
  late CollectionReference<PowerMeter> powerMetersRef;
  late CollectionReference<District> districtsRef;

  factory FirestoreHandler() {
    return _firestoreSingleton;
  }

  FirestoreHandler._internal() {
    db = FirebaseFirestore.instance;

    powerMetersRef = db.collection('PowerMeters').withConverter<PowerMeter>(
          fromFirestore: (snapshot, _) =>
              PowerMeter.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (powerMeter, _) => powerMeter.toJson(),
        );

    districtsRef = db.collection('Districts').withConverter<District>(
        fromFirestore: (snapshot, options) =>
            District.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (district, _) => district.toJson());
  }

  Future<Set<Marker>> getFilteredMeters(BuildContext context) async {
    QuerySnapshot<PowerMeter> querySnapshot =
        await powerMetersRef.getFilters().get();
    return querySnapshot.docs
        .map(
          (QueryDocumentSnapshot<PowerMeter> powerMeterDoc) => Marker(
            markerId: MarkerId(powerMeterDoc.data().id),
            position: powerMeterDoc.data().geolocation,
            onTap: () => showDialog<String>(
              context: context,
              builder: (context) => PowerMeterDetails(
                powerMeterDoc.data(),
              ),
            ),
          ),
        )
        .toSet();
  }

  Future<List<District>> getAllDistricts() async {
    QuerySnapshot<District> querySnapshot = await districtsRef.get();
    return querySnapshot.docs
        .map(
            (QueryDocumentSnapshot<District> districtDoc) => districtDoc.data())
        .toList();
  }
}

extension on Query<PowerMeter> {
  Query<PowerMeter> getFilters() {
    if (FilterHandler.selectedDistrict != null) {
      return where(
        'District',
        isEqualTo: FirestoreHandler()
            .db
            .collection('Districts')
            .doc(FilterHandler.selectedDistrict?.id),
      );
    } else {
      return limit(10);
    }
  }
}

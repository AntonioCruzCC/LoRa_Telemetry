import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lora_telemetry/controllers/power_meter.dart';

class FirestoreHandler {
  static final FirestoreHandler _firestoreSingleton =
      FirestoreHandler._internal();

  late FirebaseFirestore db;
  late CollectionReference<PowerMeter> powerMetersRef;

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
  }

  Future<Set<Marker>> getAllMeters() async {
    QuerySnapshot<PowerMeter> querySnapshot = await powerMetersRef.get();
    return querySnapshot.docs
        .map(
          (QueryDocumentSnapshot<PowerMeter> powerMeterDoc) => Marker(
              markerId: MarkerId(powerMeterDoc.data().id),
              position: powerMeterDoc.data().geolocation,
              onTap: () async {
                print((await powerMeterDoc.data().district).name);
              }),
        )
        .toSet();
  }
}

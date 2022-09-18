import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lora_telemetry/firebase_options.dart';
import 'package:lora_telemetry/handlers/filter_handler.dart';
import 'package:lora_telemetry/handlers/firestore_handler.dart';
import 'package:lora_telemetry/handlers/location_handler.dart';
import 'package:lora_telemetry/pages/map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirestoreHandler();
  LocationHandler();
  FilterHandler();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoRa Telemetry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 50,
        ),
      ),
      home: const Scaffold(
        body: MapPage(),
      ),
    );
  }
}

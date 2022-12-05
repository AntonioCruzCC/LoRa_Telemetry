import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lora_telemetry/firebase_options.dart';
import 'package:lora_telemetry/handlers/file_handler.dart';
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
  FileHandler();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoRa Telemetry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
          foregroundColor: Colors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 50,
        ),
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noThumb,
        ),
      ),
      home: const Scaffold(
        body: MapPage(),
      ),
    );
  }
}

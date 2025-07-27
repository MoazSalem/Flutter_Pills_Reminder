import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/app.dart';
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<MedicationModel>('medications');
  runApp(const MyApp());
}

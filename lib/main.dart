import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:pills_reminder/app.dart';

import 'features/main_screen/data/models/hive/medication_model_adapter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init(Directory.current.path)
    ..registerAdapter(MedicationModelAdapter());
  runApp(const MyApp());
}

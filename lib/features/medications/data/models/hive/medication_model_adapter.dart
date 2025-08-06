import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

@GenerateAdapters([AdapterSpec<MedicationModel>()])
part 'medication_model_adapter.g.dart';

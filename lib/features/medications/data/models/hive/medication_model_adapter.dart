import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:pills_reminder/core/utils/helpers.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

@GenerateAdapters([AdapterSpec<MedicationModel>()])
part 'medication_model_adapter.g.dart';

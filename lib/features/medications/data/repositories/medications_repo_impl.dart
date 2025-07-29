import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/domain/datasources/medication_local_data_source.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';
import 'package:pills_reminder/features/medications/domain/repositories/medications_repo.dart';

class MedicationsRepoImpl implements MedicationsRepo {
  final MedicationLocalDataSource localDataSource;
  MedicationsRepoImpl({required this.localDataSource});

  @override
  Future<List<Medication>> getAllMedications() {
    return localDataSource.getAll().then(
      (medications) => medications.map((med) => med.toEntity()).toList(),
    );
  }

  @override
  Future<MedicationModel> getMedication(int id) async {
    return localDataSource.get(id);
  }

  @override
  Future<void> addMedication(MedicationModel med) {
    localDataSource.add(med);
    return Future.value();
  }

  @override
  Future<void> deleteMedication(int id) {
    localDataSource.delete(id);
    return Future.value();
  }

  @override
  Future<void> updateMedication(MedicationModel med) {
    localDataSource.update(med);
    return Future.value();
  }
}

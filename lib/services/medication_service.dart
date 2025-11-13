import '../models/medication_model.dart';

class MedicationService {
  final List<MedicationModel> _medications = [];

  // Construtor privado
  MedicationService._privateConstructor();
  
  // Instância única
  static final MedicationService _instance = MedicationService._privateConstructor();
  
  // Factory constructor
  factory MedicationService() {
    return _instance;
  }

  Stream<List<MedicationModel>> getMedications(String userId) {
    // Filtra medicamentos pelo usuário e ordena
    final userMeds = _medications
        .where((med) => med.userId == userId)
        .toList()
      ..sort((a, b) {
        if (a.hour != b.hour) return a.hour.compareTo(b.hour);
        return a.minute.compareTo(b.minute);
      });
    
    print('📋 Medicamentos do usuário $userId: ${userMeds.length}');
    return Stream.value(userMeds).asBroadcastStream();
  }

  Future<void> addMedication(MedicationModel medication) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _medications.add(medication);
    print('✅ Medicamento adicionado: ${medication.name} às ${medication.formattedTime}');
  }

  Future<void> updateMedication(MedicationModel medication) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _medications.indexWhere((m) => m.id == medication.id);
    if (index != -1) {
      _medications[index] = medication;
      print('✅ Medicamento atualizado: ${medication.name}');
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _medications.removeWhere((m) => m.id == medicationId);
    print('✅ Medicamento excluído: $medicationId');
  }
}
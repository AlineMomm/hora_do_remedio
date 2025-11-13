import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication_model.dart';

class MedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MedicationModel>> getMedications(String userId) {
    return _firestore
        .collection('medications')
        .where('userId', isEqualTo: userId)
        .orderBy('hour')
        .orderBy('minute')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicationModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> addMedication(MedicationModel medication) async {
    await _firestore
        .collection('medications')
        .doc(medication.id)
        .set(medication.toMap());
  }

  Future<void> updateMedication(MedicationModel medication) async {
    await _firestore
        .collection('medications')
        .doc(medication.id)
        .update(medication.toMap());
  }

  Future<void> deleteMedication(String medicationId) async {
    await _firestore.collection('medications').doc(medicationId).delete();
  }

  Future<MedicationModel?> getMedicationById(String medicationId) async {
    final doc =
        await _firestore.collection('medications').doc(medicationId).get();
    if (doc.exists) {
      return MedicationModel.fromMap(doc.data()!);
    }
    return null;
  }
}
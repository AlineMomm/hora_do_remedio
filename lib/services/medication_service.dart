import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication_model.dart';

class MedicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MedicationService._privateConstructor();
  static final MedicationService _instance = MedicationService._privateConstructor();
  factory MedicationService() => _instance;

  Stream<List<MedicationModel>> getMedications(String userId) {
    print('🔍 INICIANDO STREAM para usuário: $userId');
    
    return _firestore
        .collection('medications')
        .where('userId', isEqualTo: userId)
        .orderBy('hour')
        .orderBy('minute')
        .snapshots()
        .handleError((error) {
          print('❌ ERRO CRÍTICO NO STREAM: $error');
          print('📋 Tipo do erro: ${error.runtimeType}');
          if (error is FirebaseException) {
            print('🔐 Código do Firebase: ${error.code}');
            print('📝 Mensagem: ${error.message}');
          }
        })
        .map((snapshot) {
          print('📡 SNAPSHOT RECEBIDO:');
          print('📊 Número de documentos: ${snapshot.docs.length}');
          print('🔢 Tamanho do snapshot: ${snapshot.size}');
          print('📋 Mudanças: ${snapshot.docChanges.length}');
          
          // Debug de CADA documento
          for (var i = 0; i < snapshot.docs.length; i++) {
            final doc = snapshot.docs[i];
            final data = doc.data();
            print('📄 Documento $i: ${doc.id}');
            print('   🏷️  Nome: ${data['name']}');
            print('   👤 UserId: ${data['userId']}');
            print('   ⏰ Hora: ${data['hour']}:${data['minute']}');
            print('   📅 CreatedAt: ${data['createdAt']}');
          }
          
          final medications = snapshot.docs.map((doc) {
            final data = doc.data();
            print('🔄 Convertendo documento: ${data['name']}');
            
            return MedicationModel(
              id: doc.id,
              userId: data['userId'] ?? '',
              name: data['name'] ?? '',
              hour: data['hour'] ?? 0,
              minute: data['minute'] ?? 0,
              frequency: data['frequency'] ?? 'Diário',
              notes: data['notes'],
              createdAt: data['createdAt'] != null 
                  ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int)
                  : DateTime.now(),
            );
          }).toList();
          
          print('🎯 TOTAL DE MEDICAMENTOS CONVERTIDOS: ${medications.length}');
          
          for (var med in medications) {
            print('💊 Medicamento na lista: ${med.name} (${med.formattedTime})');
          }
          
          return medications;
        });
  }

  Future<void> addMedication(MedicationModel medication) async {
    try {
      print('🔄 Salvando medicamento: ${medication.name}');
      
      final docRef = _firestore.collection('medications').doc();
      
      await docRef.set({
        'userId': medication.userId,
        'name': medication.name,
        'hour': medication.hour,
        'minute': medication.minute,
        'frequency': medication.frequency,
        'notes': medication.notes,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      
      print('✅ Medicamento salvo! ID: ${docRef.id}');
      
    } catch (e) {
      print('❌ Erro ao salvar: $e');
      throw 'Erro ao salvar medicamento: $e';
    }
  }

  Future<void> updateMedication(MedicationModel medication) async {
    try {
      await _firestore
          .collection('medications')
          .doc(medication.id)
          .update({
            'name': medication.name,
            'hour': medication.hour,
            'minute': medication.minute,
            'frequency': medication.frequency,
            'notes': medication.notes,
          });
      
      print('✅ Medicamento atualizado!');
    } catch (e) {
      print('❌ Erro ao atualizar: $e');
      throw 'Erro ao atualizar medicamento: $e';
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    try {
      await _firestore
          .collection('medications')
          .doc(medicationId)
          .delete();
      
      print('✅ Medicamento excluído!');
    } catch (e) {
      print('❌ Erro ao excluir: $e');
      throw 'Erro ao excluir medicamento: $e';
    }
  }
}
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/medication_service.dart';
import '../models/medication_model.dart';
import 'add_medication_page.dart'; // ← ADICIONAR ESTA IMPORT
import 'login_page.dart';

class MedicationListPage extends StatefulWidget {
  final AuthService authService;
  
  const MedicationListPage({super.key, required this.authService});

  @override
  State<MedicationListPage> createState() => _MedicationListPageState();
}

class _MedicationListPageState extends State<MedicationListPage> {
  final MedicationService _medicationService = MedicationService();
  late Stream<List<MedicationModel>> _medicationsStream;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  void _loadMedications() {
    final userId = widget.authService.currentUser?.uid ?? 'test-user';
    _medicationsStream = _medicationService.getMedications(userId);
  }

  void _logout() async {
    await widget.authService.signOut();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _confirmDeleteMedication(MedicationModel medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Medicamento'),
        content: Text('Tem certeza que deseja excluir "${medication.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMedication(medication.id);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteMedication(String medicationId) async {
    try {
      await _medicationService.deleteMedication(medicationId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicamento excluído com sucesso!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir medicamento: $e'),
          backgroundColor: const Color(0xFFD32F2F),
        ),
      );
    }
  }

  void _editMedication(MedicationModel medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicationPage( // ← CORRIGIDO
          medication: medication,
          authService: widget.authService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Meus Medicamentos'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: StreamBuilder<List<MedicationModel>>(
        stream: _medicationsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFD32F2F),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar medicamentos',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFFE91E63)),
              ),
            );
          }

          final medications = snapshot.data ?? [];

          if (medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                    width: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nenhum medicamento cadastrado',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toque no botão + para adicionar seu primeiro medicamento',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final medication = medications[index];
              return _buildMedicationCard(medication);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicationPage( // ← CORRIGIDO
                authService: widget.authService,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicationCard(MedicationModel medication) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    medication.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC2185B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editMedication(medication),
                      color: const Color(0xFFE91E63),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _confirmDeleteMedication(medication),
                      color: const Color(0xFFD32F2F),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Horário: ${medication.formattedTime}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.repeat,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Frequência: ${medication.frequency}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (medication.notes != null && medication.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Observações: ${medication.notes}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
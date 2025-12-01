import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final AuthService authService;
  
  const ProfilePage({super.key, required this.authService});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _observationsController;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = widget.authService.currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _ageController = TextEditingController(text: user?.age?.toString() ?? '');
    _bloodTypeController = TextEditingController(text: user?.bloodType ?? '');
    _emergencyNameController = TextEditingController(text: user?.emergencyContactName ?? '');
    _emergencyPhoneController = TextEditingController(text: user?.emergencyContactPhone ?? '');
    _observationsController = TextEditingController(text: user?.observations ?? '');
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Se cancelou a edição, volta os valores originais
        _initializeControllers();
      }
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final currentUser = widget.authService.currentUser;
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            age: int.tryParse(_ageController.text.trim()),
            bloodType: _bloodTypeController.text.trim(),
            emergencyContactName: _emergencyNameController.text.trim(),
            emergencyContactPhone: _emergencyPhoneController.text.trim(),
            observations: _observationsController.text.trim(),
          );

          // Atualiza no serviço (em memória)
          widget.authService.currentUser = updatedUser;

          if (!mounted) return;
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
          
          setState(() {
            _isEditing = false;
          });
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: $e'),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFFE91E63),
          backgroundImage: widget.authService.currentUser?.profileImageUrl != null
              ? NetworkImage(widget.authService.currentUser!.profileImageUrl!)
              : null,
          child: widget.authService.currentUser?.profileImageUrl == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                )
              : null,
        ),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE91E63),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: _changeProfileImage,
              ),
            ),
          ),
      ],
    );
  }

  void _changeProfileImage() {
    // Por enquanto é apenas simulado
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Foto'),
        content: const Text('Funcionalidade de câmera/galeria será implementada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
            tooltip: _isEditing ? 'Cancelar' : 'Editar',
          ),
          if (_isEditing)
            IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveProfile,
              tooltip: 'Salvar',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto de Perfil
              _buildProfileImage(),
              const SizedBox(height: 20),
              
              // Informações Pessoais
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC2185B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Nome
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                          prefixIcon: Icon(Icons.person),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (_isEditing && (value == null || value.isEmpty)) {
                            return 'Por favor, digite seu nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Email (não editável)
                      TextFormField(
                        initialValue: user?.email,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email),
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      
                      // Telefone
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      
                      // Idade
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Idade',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        enabled: _isEditing,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      
                      // Tipo Sanguíneo
                      TextFormField(
                        controller: _bloodTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Tipo Sanguíneo',
                          prefixIcon: Icon(Icons.bloodtype),
                        ),
                        enabled: _isEditing,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Contato de Emergência
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contato de Emergência',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC2185B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Nome do Contato
                      TextFormField(
                        controller: _emergencyNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do contato',
                          prefixIcon: Icon(Icons.contact_emergency),
                        ),
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      
                      // Telefone do Contato
                      TextFormField(
                        controller: _emergencyPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone do contato',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Observações
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC2185B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _observationsController,
                        decoration: const InputDecoration(
                          labelText: 'Observações médicas ou alergias',
                          prefixIcon: Icon(Icons.note),
                        ),
                        enabled: _isEditing,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _bloodTypeController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _observationsController.dispose();
    super.dispose();
  }
}
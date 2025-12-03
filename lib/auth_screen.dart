import '../models/user_model.dart';
import '../services/local_storage_service.dart';

class AuthService {
  final LocalStorageService _storage = LocalStorageService();
  UserModel? currentUser;

  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();
  factory AuthService() => _instance;

  // Gerar ID único
  String _generateUid() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<UserModel?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      print('🔄 Tentando registrar: $email');
      
      // Verificar se email já existe
      final existingUser = await _storage.getUserByEmail(email);
      if (existingUser != null) {
        throw 'Este e-mail já está cadastrado';
      }
      
      // Validar senha
      if (password.length < 6) {
        throw 'Senha muito fraca (mínimo 6 caracteres)';
      }
      
      // Validar email
      if (!email.contains('@') || !email.contains('.')) {
        throw 'E-mail inválido';
      }
      
      // Criar novo usuário
      final newUser = UserModel(
        uid: _generateUid(),
        name: name,
        email: email,
      );
      
      // Salvar no storage
      await _storage.saveUser(newUser.toMap());
      
      // Definir como usuário atual
      currentUser = newUser;
      await _storage.setCurrentUser(newUser.uid);
      
      print('✅ Usuário criado: ${newUser.uid}');
      return currentUser;
    } catch (e) {
      print('❌ Erro no registro: $e');
      throw 'Erro no cadastro: $e';
    }
  }

  Future<UserModel?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      print('🔄 Tentando login: $email');
      
      // Validar email
      if (!email.contains('@') || !email.contains('.')) {
        throw 'E-mail inválido';
      }
      
      // Buscar usuário pelo email
      final userData = await _storage.getUserByEmail(email);
      
      if (userData == null) {
        throw 'Usuário não encontrado';
      }
      
      // Converter para UserModel
      currentUser = UserModel.fromMap(userData);
      
      // Definir como usuário atual
      await _storage.setCurrentUser(currentUser!.uid);
      
      print('✅ Login bem-sucedido: ${currentUser!.uid}');
      return currentUser;
    } catch (e) {
      print('❌ Erro no login: $e');
      throw 'Erro no login: $e';
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is String) {
      if (error.contains('já está cadastrado')) {
        return 'Este e-mail já está cadastrado';
      }
      if (error.contains('inválido')) {
        return 'E-mail inválido';
      }
      if (error.contains('fraca')) {
        return 'Senha muito fraca (mínimo 6 caracteres)';
      }
      if (error.contains('não encontrado')) {
        return 'Usuário não encontrado';
      }
      return error;
    }
    return 'Erro: $error';
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await _storage.saveUser(updatedUser.toMap());
      currentUser = updatedUser;
      print('✅ Perfil atualizado!');
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      throw 'Erro ao atualizar perfil: $e';
    }
  }

  Future<void> signOut() async {
    await _storage.setCurrentUser(null);
    currentUser = null;
    print('✅ Usuário deslogado');
  }

  Future<UserModel?> getCurrentUser() async {
    if (currentUser != null) return currentUser;
    
    final userId = await _storage.getCurrentUserId();
    if (userId == null) return null;
    
    final userData = await _storage.getUserById(userId);
    if (userData == null) return null;
    
    currentUser = UserModel.fromMap(userData);
    return currentUser;
  }
}
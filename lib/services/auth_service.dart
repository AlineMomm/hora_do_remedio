import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserModel? currentUser;

  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();
  factory AuthService() => _instance;

  Future<UserModel?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      print('🔄 Tentando registrar: $email');
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        print('✅ Usuário criado no Firebase: ${user.uid}');
        
        currentUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
        );
        
        return currentUser;
      }
      return null;
    } catch (e) {
      print('❌ Erro no registro: $e');
      // Se der erro no Firebase, usa fallback local
      return _registerLocal(name, email, password);
    }
  }

  Future<UserModel?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      print('🔄 Tentando login: $email');
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        print('✅ Usuário logado no Firebase: ${user.uid}');
        
        currentUser = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'Usuário',
          email: user.email ?? email,
        );
        
        return currentUser;
      }
      return null;
    } catch (e) {
      print('❌ Erro no login Firebase: $e');
      // Fallback para login local
      return _loginLocal(email, password);
    }
  }

  // Fallback local para quando Firebase falhar
  Future<UserModel?> _registerLocal(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulação de cadastro local
    currentUser = UserModel(
      uid: 'local-user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
    );
    
    print('✅ Cadastro local (fallback): $email');
    return currentUser;
  }

  Future<UserModel?> _loginLocal(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulação de login local
    currentUser = UserModel(
      uid: 'local-user-123',
      name: 'Usuário Local',
      email: email,
    );
    
    print('✅ Login local (fallback): $email');
    return currentUser;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('❌ Erro no logout Firebase: $e');
    }
    currentUser = null;
    print('✅ Usuário deslogado');
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    currentUser = updatedUser;
    print('✅ Perfil atualizado: ${updatedUser.name}');
}
}
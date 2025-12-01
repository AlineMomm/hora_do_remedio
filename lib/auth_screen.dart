import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
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

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(currentUser!.toMap());
        
        print('✅ Perfil salvo no Firestore!');
        return currentUser;
      }
      return null;
    } catch (e) {
      print('❌ Erro no registro: $e');
      throw 'Erro no cadastro: ${_getErrorMessage(e)}';
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
        print('✅ Login bem-sucedido: ${user.uid}');
        
        DocumentSnapshot userDoc = 
            await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
          print('✅ Perfil carregado do Firestore');
        } else {
          currentUser = UserModel(
            uid: user.uid,
            name: user.displayName ?? 'Usuário',
            email: user.email ?? email,
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(currentUser!.toMap());
          print('✅ Novo perfil criado no Firestore');
        }
        
        return currentUser;
      }
      return null;
    } catch (e) {
      print('❌ Erro no login: $e');
      throw 'Erro no login: ${_getErrorMessage(e)}';
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado';
        case 'invalid-email':
          return 'E-mail inválido';
        case 'weak-password':
          return 'Senha muito fraca (mínimo 6 caracteres)';
        case 'user-not-found':
          return 'Usuário não encontrado';
        case 'wrong-password':
          return 'Senha incorreta';
        default:
          return 'Erro: ${error.message ?? error.code}';
      }
    }
    return 'Erro: $error';
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());
      
      currentUser = updatedUser;
      print('✅ Perfil atualizado no Firestore');
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      throw 'Erro ao atualizar perfil: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    print('✅ Usuário deslogado');
  }
}
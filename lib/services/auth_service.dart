import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

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
      print('📝 Nome: $name, Senha: ${'*' * password.length}');
      
      // Verifica se o Firebase está inicializado
      print('🔥 Firebase Auth instance: $_auth');
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Usuário criado no Auth: ${result.user?.uid}');

      User? user = result.user;

      if (user != null) {
        print('📝 Criando documento no Firestore...');
        
        currentUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
        );

        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(currentUser!.toMap());
          
          print('✅ Perfil salvo no Firestore com sucesso!');
          return currentUser;
        } catch (firestoreError) {
          print('❌ Erro no Firestore: $firestoreError');
          // Se der erro no Firestore, pelo menos o usuário foi criado no Auth
          return currentUser;
        }
      }
      return null;
    } catch (e) {
      print('❌ ERRO COMPLETO NO REGISTRO:');
      print('❌ Tipo do erro: ${e.runtimeType}');
      print('❌ Mensagem: $e');
      
      if (e is FirebaseAuthException) {
        print('❌ Código do erro: ${e.code}');
        print('❌ Mensagem do Firebase: ${e.message}');
        print('❌ StackTrace: ${e.stackTrace}');
      }
      
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
        print('✅ Login bem-sucedido no Auth: ${user.uid}');
        print('📝 Buscando dados no Firestore...');
        
        try {
          DocumentSnapshot userDoc = 
              await _firestore.collection('users').doc(user.uid).get();
          
          if (userDoc.exists) {
            currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
            print('✅ Perfil carregado do Firestore: ${currentUser!.email}');
          } else {
            print('⚠️  Usuário não encontrado no Firestore, criando novo...');
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
        } catch (firestoreError) {
          print('❌ Erro no Firestore durante login: $firestoreError');
          // Fallback: cria usuário básico
          currentUser = UserModel(
            uid: user.uid,
            name: 'Usuário',
            email: email,
          );
          return currentUser;
        }
      }
      return null;
    } catch (e) {
      print('❌ ERRO COMPLETO NO LOGIN:');
      print('❌ Tipo do erro: ${e.runtimeType}');
      print('❌ Mensagem: $e');
      
      if (e is FirebaseAuthException) {
        print('❌ Código do erro: ${e.code}');
        print('❌ Mensagem do Firebase: ${e.message}');
      }
      
      throw 'Erro no login: ${_getErrorMessage(e)}';
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado. Tente fazer login.';
        case 'invalid-email':
          return 'E-mail inválido. Verifique o formato.';
        case 'weak-password':
          return 'Senha muito fraca. Use pelo menos 6 caracteres.';
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o e-mail.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'network-request-failed':
          return 'Erro de conexão. Verifique sua internet.';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde.';
        default:
          return 'Erro: ${error.message ?? error.code}';
      }
    }
    
    // Erros genéricos
    if (error.toString().contains('firebase')) {
      return 'Erro de conexão com o servidor. Tente novamente.';
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
      print('✅ Perfil atualizado no Firestore: ${updatedUser.name}');
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      throw 'Erro ao atualizar perfil: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser = null;
      print('✅ Usuário deslogado');
    } catch (e) {
      print('❌ Erro no logout: $e');
      throw 'Erro ao sair: $e';
    }
  }

  // Verifica se há usuário logado atualmente
  Future<bool> isUserLoggedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      print('👤 Usuário já está logado: ${user.email}');
      return true;
    }
    print('👤 Nenhum usuário logado');
    return false;
  }
}
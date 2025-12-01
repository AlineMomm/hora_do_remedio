import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('🔥 Inicializando Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado!');
    
    // Teste direto do Firestore
    final firestore = FirebaseFirestore.instance;
    print('📡 Firestore instance: $firestore');
    
    // Tente uma operação simples
    try {
      await firestore.collection('test').add({
        'message': 'Teste de conexão',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Teste de escrita no Firestore: SUCESSO!');
    } catch (e) {
      print('❌ Teste de escrita no Firestore: $e');
    }
    
  } catch (e) {
    print('❌ Erro na inicialização: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hora do Remédio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFE91E63),
          secondary: const Color(0xFFF8BBD0),
          error: const Color(0xFFD32F2F),
        ),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFC2185B)),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFC2185B)),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE91E63)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC2185B), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFFE91E63)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
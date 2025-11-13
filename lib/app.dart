import 'package:flutter/material.dart';
import 'auth_screen.dart';

class HoraDoRemedioApp extends StatelessWidget {
  const HoraDoRemedioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hora do Remédio',
      theme: ThemeData(
        primaryColor: const Color(0xFFD32F2F), // Vermelho
        scaffoldBackgroundColor: const Color(0xFFFFF5F5), // Rosa bem clarinho
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          backgroundColor: const Color(0xFFFFF5F5), // Fundo rosa claro
        ).copyWith(
          secondary: const Color(0xFFF44336), // Vermelho mais claro
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Color(0xFFD32F2F), // Vermelho
          ),
          displayMedium: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: Color(0xFFD32F2F), // Vermelho
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFFB71C1C), // Vermelho escuro
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFFB71C1C), // Vermelho escuro
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFCDD2)), // Borda rosa
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFCDD2)), // Borda rosa
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD32F2F)), // Borda vermelha quando focado
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(color: Color(0xFFD32F2F)), // Label vermelho
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F), // Fundo vermelho
            foregroundColor: Colors.white, // Texto branco
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFD32F2F), // Texto vermelho
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
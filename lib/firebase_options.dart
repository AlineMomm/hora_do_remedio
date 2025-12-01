import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ✅ SUAS CONFIGURAÇÕES REAIS DO FIREBASE
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyD0tfZX7X-jLugFD_y0XmA8fra5OF7H8aQ",
    authDomain: "hora-do-remedio-165b3.firebaseapp.com",
    projectId: "hora-do-remedio-165b3",
    storageBucket: "hora-do-remedio-165b3.firebasestorage.app",
    messagingSenderId: "828522686230",
    appId: "1:828522686230:web:60be81373bcf74e8671237",
  );

  // Para Android/iOS pode manter genérico por enquanto
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyD0tfZX7X-jLugFD_y0XmA8fra5OF7H8aQ",
    appId: "1:828522686230:android:60be81373bcf74e8671237",
    messagingSenderId: "828522686230",
    projectId: "hora-do-remedio-165b3",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyD0tfZX7X-jLugFD_y0XmA8fra5OF7H8aQ",
    appId: "1:828522686230:ios:60be81373bcf74e8671237",
    messagingSenderId: "828522686230",
    projectId: "hora-do-remedio-165b3",
    iosBundleId: "com.example.horaDoRemedio",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyD0tfZX7X-jLugFD_y0XmA8fra5OF7H8aQ",
    appId: "1:828522686230:ios:60be81373bcf74e8671237",
    messagingSenderId: "828522686230",
    projectId: "hora-do-remedio-165b3",
    iosBundleId: "com.example.horaDoRemedio",
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyD0tfZX7X-jLugFD_y0XmA8fra5OF7H8aQ",
    appId: "1:828522686230:web:60be81373bcf74e8671237",
    messagingSenderId: "828522686230",
    projectId: "hora-do-remedio-165b3",
  );
}
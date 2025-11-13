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

  // Configurações genéricas para teste
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBdR3k9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q",
    authDomain: "hora-do-remedio-test.firebaseapp.com",
    projectId: "hora-do-remedio-test",
    storageBucket: "hora-do-remedio-test.appspot.com",
    messagingSenderId: "123456789012",
    appId: "1:123456789012:web:abcdef123456789",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBdR3k9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q",
    appId: "1:123456789012:android:abcdef123456789",
    messagingSenderId: "123456789012",
    projectId: "hora-do-remedio-test",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBdR3k9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q",
    appId: "1:123456789012:ios:abcdef123456789",
    messagingSenderId: "123456789012",
    projectId: "hora-do-remedio-test",
    iosBundleId: "com.example.horaDoRemedio",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyBdR3k9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q",
    appId: "1:123456789012:ios:abcdef123456789",
    messagingSenderId: "123456789012",
    projectId: "hora-do-remedio-test",
    iosBundleId: "com.example.horaDoRemedio",
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyBdR3k9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q",
    appId: "1:123456789012:web:abcdef123456789",
    messagingSenderId: "123456789012",
    projectId: "hora-do-remedio-test",
  );
}
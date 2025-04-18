// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFF0i0b6MJGdY0Xp9L_6UpbuqbVhHSLDA',
    appId: '1:853914984095:web:870fdbfb9c76bf1655ccaa',
    messagingSenderId: '853914984095',
    projectId: 'a12-inventory-management-app',
    authDomain: 'a12-inventory-management-app.firebaseapp.com',
    storageBucket: 'a12-inventory-management-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAog4OUR-TF_8XmEcHKdcXWOV8l4ZI6Yys',
    appId: '1:853914984095:android:5ca0a2d3976c47e855ccaa',
    messagingSenderId: '853914984095',
    projectId: 'a12-inventory-management-app',
    storageBucket: 'a12-inventory-management-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRD_kPyaAiqZfJ8Gip8KYrbg8fs_iqhJ8',
    appId: '1:853914984095:ios:0faea173d697474155ccaa',
    messagingSenderId: '853914984095',
    projectId: 'a12-inventory-management-app',
    storageBucket: 'a12-inventory-management-app.firebasestorage.app',
    iosBundleId: 'com.example.a12',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDRD_kPyaAiqZfJ8Gip8KYrbg8fs_iqhJ8',
    appId: '1:853914984095:ios:0faea173d697474155ccaa',
    messagingSenderId: '853914984095',
    projectId: 'a12-inventory-management-app',
    storageBucket: 'a12-inventory-management-app.firebasestorage.app',
    iosBundleId: 'com.example.a12',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDFF0i0b6MJGdY0Xp9L_6UpbuqbVhHSLDA',
    appId: '1:853914984095:web:7e7d8271f56504e655ccaa',
    messagingSenderId: '853914984095',
    projectId: 'a12-inventory-management-app',
    authDomain: 'a12-inventory-management-app.firebaseapp.com',
    storageBucket: 'a12-inventory-management-app.firebasestorage.app',
  );
}

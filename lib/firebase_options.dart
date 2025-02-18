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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCymCFU1skBDd022LYu95w--fa43D10jKU',
    appId: '1:824636639600:web:e353654bdc8c1bb23de7b5',
    messagingSenderId: '824636639600',
    projectId: 'flutterfire-ef2b1',
    authDomain: 'flutterfire-ef2b1.firebaseapp.com',
    databaseURL: 'https://flutterfire-ef2b1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutterfire-ef2b1.firebasestorage.app',
    measurementId: 'G-LV04Q5MT41',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtwVSJ8mKTK2Zplpd-q9Z9ioMQiwnQx0Y',
    appId: '1:824636639600:android:ed99059b14b755923de7b5',
    messagingSenderId: '824636639600',
    projectId: 'flutterfire-ef2b1',
    databaseURL: 'https://flutterfire-ef2b1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutterfire-ef2b1.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCymCFU1skBDd022LYu95w--fa43D10jKU',
    appId: '1:824636639600:web:6fde7602b84e75fc3de7b5',
    messagingSenderId: '824636639600',
    projectId: 'flutterfire-ef2b1',
    authDomain: 'flutterfire-ef2b1.firebaseapp.com',
    databaseURL: 'https://flutterfire-ef2b1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutterfire-ef2b1.firebasestorage.app',
    measurementId: 'G-5GR4NYG1JS',
  );

}
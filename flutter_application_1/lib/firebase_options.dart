// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA7n0NObQRDPvr3qvcFF4hjD7Wx8QAVdpw',
    appId: '1:246720325248:web:5f267ea2be3288a04aa865',
    messagingSenderId: '246720325248',
    projectId: 'tps-project-app',
    authDomain: 'tps-project-app.firebaseapp.com',
    storageBucket: 'tps-project-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCH8rFXuARSTT0zv28EzxNT5n-Z-vg9Fg',
    appId: '1:246720325248:android:ea9cadba1b9458a74aa865',
    messagingSenderId: '246720325248',
    projectId: 'tps-project-app',
    storageBucket: 'tps-project-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmM4sFp4jq4jd_dPPORIf77YQQigSbnQM',
    appId: '1:246720325248:ios:85e1f2bbef129f7f4aa865',
    messagingSenderId: '246720325248',
    projectId: 'tps-project-app',
    storageBucket: 'tps-project-app.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmM4sFp4jq4jd_dPPORIf77YQQigSbnQM',
    appId: '1:246720325248:ios:8b8c739a96d88b604aa865',
    messagingSenderId: '246720325248',
    projectId: 'tps-project-app',
    storageBucket: 'tps-project-app.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}

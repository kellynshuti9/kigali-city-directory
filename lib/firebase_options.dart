
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
    apiKey: 'AIzaSyA_NbowYZoGhczP3PzCBHHGnMhpimvuvKU',
    appId: '1:11415159556:web:468a8cb4b1023b933fc651',
    messagingSenderId: '11415159556',
    projectId: 'kigali-city-directory-f8737',
    authDomain: 'kigali-city-directory-f8737.firebaseapp.com',
    databaseURL: 'https://kigali-city-directory-f8737-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kigali-city-directory-f8737.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZWKboOQUr1qQVw4pXVrLd5LRR_WfPXYo',
    appId: '1:11415159556:ios:6223b2a57900423f3fc651',
    messagingSenderId: '11415159556',
    projectId: 'kigali-city-directory-f8737',
    databaseURL: 'https://kigali-city-directory-f8737-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kigali-city-directory-f8737.firebasestorage.app',
    iosBundleId: 'com.example.kigaliCityDirectory',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZWKboOQUr1qQVw4pXVrLd5LRR_WfPXYo',
    appId: '1:11415159556:ios:6223b2a57900423f3fc651',
    messagingSenderId: '11415159556',
    projectId: 'kigali-city-directory-f8737',
    databaseURL: 'https://kigali-city-directory-f8737-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kigali-city-directory-f8737.firebasestorage.app',
    iosBundleId: 'com.example.kigaliCityDirectory',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA_NbowYZoGhczP3PzCBHHGnMhpimvuvKU',
    appId: '1:11415159556:web:c94b9b608e7abd3f3fc651',
    messagingSenderId: '11415159556',
    projectId: 'kigali-city-directory-f8737',
    authDomain: 'kigali-city-directory-f8737.firebaseapp.com',
    databaseURL: 'https://kigali-city-directory-f8737-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kigali-city-directory-f8737.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOj8grTSbx92XS8fhrcxvV3brVvFiee1k',
    appId: '1:11415159556:android:ed5faaae58707cc43fc651',
    messagingSenderId: '11415159556',
    projectId: 'kigali-city-directory-f8737',
    databaseURL: 'https://kigali-city-directory-f8737-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kigali-city-directory-f8737.firebasestorage.app',
  );

}
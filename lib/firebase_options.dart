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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD3uMm4UcP7wuCOf5MIIZeYubJ149BxLfQ',
    appId: '1:51674426664:web:51c3c6ec963f60b770341d',
    messagingSenderId: '51674426664',
    projectId: 'facebook-316f7',
    authDomain: 'facebook-316f7.firebaseapp.com',
    storageBucket: 'facebook-316f7.appspot.com',
    measurementId: 'G-11E409LZCM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWTi-GAxYy5RV7-QKbAXv8JF6rqXUqT00',
    appId: '1:51674426664:android:56763a1b7bcd059170341d',
    messagingSenderId: '51674426664',
    projectId: 'facebook-316f7',
    storageBucket: 'facebook-316f7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfg2JWkSnXFZaY_JHHOerZyO_FRp8utiY',
    appId: '1:51674426664:ios:74e0d8374382125a70341d',
    messagingSenderId: '51674426664',
    projectId: 'facebook-316f7',
    storageBucket: 'facebook-316f7.appspot.com',
    iosClientId: '51674426664-2ludsn5nfthl4o4qpv4u7bp0pv2n1sbp.apps.googleusercontent.com',
    iosBundleId: 'com.juhwan976.facebook',
  );
}

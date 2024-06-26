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
    apiKey: 'AIzaSyCIhZW6Njkx539aNBYLIizugGETxFXjDRQ',
    appId: '1:332225472991:web:464a87ba85f45384bcfc6a',
    messagingSenderId: '332225472991',
    projectId: 'mydocs-d984c',
    authDomain: 'mydocs-d984c.firebaseapp.com',
    storageBucket: 'mydocs-d984c.appspot.com',
    measurementId: 'G-GDW0SCVB0Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA87pPVS2eobrFChU804lXB55VzdVWWreo',
    appId: '1:332225472991:android:f0e69b456058967ebcfc6a',
    messagingSenderId: '332225472991',
    projectId: 'mydocs-d984c',
    storageBucket: 'mydocs-d984c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCne_krZ-pCne_K90Zmq6DIU7Vb0Mr1VpI',
    appId: '1:332225472991:ios:fde8d040d46989c3bcfc6a',
    messagingSenderId: '332225472991',
    projectId: 'mydocs-d984c',
    storageBucket: 'mydocs-d984c.appspot.com',
    iosBundleId: 'com.ara.mydoc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCne_krZ-pCne_K90Zmq6DIU7Vb0Mr1VpI',
    appId: '1:332225472991:ios:fde8d040d46989c3bcfc6a',
    messagingSenderId: '332225472991',
    projectId: 'mydocs-d984c',
    storageBucket: 'mydocs-d984c.appspot.com',
    iosBundleId: 'com.ara.mydoc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIhZW6Njkx539aNBYLIizugGETxFXjDRQ',
    appId: '1:332225472991:web:fa6531bab3f6ad93bcfc6a',
    messagingSenderId: '332225472991',
    projectId: 'mydocs-d984c',
    authDomain: 'mydocs-d984c.firebaseapp.com',
    storageBucket: 'mydocs-d984c.appspot.com',
    measurementId: 'G-LEE61SYXZD',
  );
}

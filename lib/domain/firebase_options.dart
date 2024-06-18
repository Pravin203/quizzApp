import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
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
    apiKey: 'AIzaSyBaTn-ILe8sAtAZfFgWFrX0sS6qG2k',
    appId: '1:4493700764eb:8b3c6da5aea86dba63cf1',
    messagingSenderId: '449075364',
    projectId: 'brovi-card',
    authDomain: 'brovi-card.firebaseapp.com',
    storageBucket: 'brovi-card.appspot.com',
    measurementId: 'G-H20N7JW4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYc5vDf8DNhLAIS6sN67NeWWVeiitjCDY',
    appId: '1:166691929216:android:9dcfbd7565175c19697a65',
    messagingSenderId: '166691929216',
    projectId: 'quizapp-e8e22',
    storageBucket: 'quizapp-e8e22.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaioJ7YMnBYdNWkh6AYAkjOtxs',
    appId: '1:44937064:ios:e6339d10b157fa63cf1',
    messagingSenderId: '440764',
    projectId: 'brovi-card',
    storageBucket: 'brovi-card.apps.com',
    androidClientId:
    '44075364-8slka1o17qam7u4mv31k6gcb7ung6t88.apps.googleusercontent.com',
    iosClientId:
    '44075364-vrrjftfpq65avsfdot681j0pbqkubm9i.apps.googleusercontent.com',
    iosBundleId: 'com.example.digitalcard',
  );
}
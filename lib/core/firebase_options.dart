import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return firebaseConfig;
  }

  static const FirebaseOptions firebaseConfig = FirebaseOptions(
    apiKey: 'AIzaSyC5gVfzr2VTkvpfHtHS72GZhg0tfBAMURg',
    appId: '1:570870926258:android:ef4d45ebbb408395d2b2ab',
    messagingSenderId: '570870926258',
    projectId: 'sila-321715',
    storageBucket: 'sila-321715.appspot.com',
  );
}
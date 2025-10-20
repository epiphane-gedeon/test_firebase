import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseEmulator {
  static Future<void> setup() async {
    if (!kDebugMode) return; // ⚡️ Ne configurer que pour le debug

    try {
      // ⚡️ Web et Mobile ont des méthodes légèrement différentes
      if (kIsWeb) {
        // Web: use the package-specific emulator methods
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8090);
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      } else {
        final firestore = FirebaseFirestore.instance;
        final auth = FirebaseAuth.instance;
        final storage = FirebaseStorage.instance;

        // Mobile/Desktop: use the package-specific emulator methods
        firestore.useFirestoreEmulator('localhost', 8090);
        await auth.useAuthEmulator('localhost', 9099);
        await storage.useStorageEmulator('localhost', 9199);
      }

      debugPrint('✅ Firebase Emulator configured successfully');
    } catch (e) {
      debugPrint('❌ Emulator setup failed: $e');
    }
  }
}

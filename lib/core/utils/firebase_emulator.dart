import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class FirebaseEmulator {
  static Future<void> setup() async {
    if (!kDebugMode) return; // ⚡️ Ne configurer que pour le debug

    try {
      // ⚡️ Determine the correct host for emulator connection
      String emulatorHost;
      if (kIsWeb) {
        emulatorHost = 'localhost';
      } else if (Platform.isAndroid) {
        // Android emulator uses 10.0.2.2 to access host machine
        emulatorHost = '10.0.2.2';
      } else {
        // iOS simulator and other platforms can use localhost
        emulatorHost = 'localhost';
      }

      if (kIsWeb) {
        // Web: use the package-specific emulator methods
        FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8090);
        await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
        FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
      } else {
        final firestore = FirebaseFirestore.instance;
        final auth = FirebaseAuth.instance;
        final storage = FirebaseStorage.instance;

        // Mobile/Desktop: use the package-specific emulator methods
        firestore.useFirestoreEmulator(emulatorHost, 8090);
        await auth.useAuthEmulator(emulatorHost, 9099);
        await storage.useStorageEmulator(emulatorHost, 9199);
      }

      debugPrint(
        '✅ Firebase Emulator configured successfully with host: $emulatorHost',
      );
    } catch (e) {
      debugPrint('❌ Emulator setup failed: $e');
    }
  }
}

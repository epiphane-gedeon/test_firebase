import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class FirebaseEmulator {
  static Future<void> setup() async {
    if (!kDebugMode) return; // ⚡️ Ne configurer que pour le debug

    try {
      // Déterminer le bon host
      String emulatorHost;
      if (kIsWeb) {
        emulatorHost = 'localhost';
      } else if (Platform.isAndroid) {
        // Android emulator -> loopback
        emulatorHost = '10.0.2.2';
      } else {
        emulatorHost = 'localhost';
      }

      if (kIsWeb) {
        // Web: use the package-specific emulator methods
        FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
        await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
        FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);

        // Fix spécial Web pour éviter les erreurs de stream
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: false,
          sslEnabled: false,
          host: "localhost:8080",
        );
      } else {
        final firestore = FirebaseFirestore.instance;
        final auth = FirebaseAuth.instance;
        final storage = FirebaseStorage.instance;

        // Mobile/Desktop: use the package-specific emulator methods
        firestore.useFirestoreEmulator(emulatorHost, 8080);
        await auth.useAuthEmulator(emulatorHost, 9099);
        await storage.useStorageEmulator(emulatorHost, 9199);
      }

      debugPrint(
        '✅ Firebase Emulator configuré avec succès avec host: $emulatorHost',
      );
    } catch (e) {
      debugPrint('❌ Erreur configuration emulator: $e');
    }
  }
}

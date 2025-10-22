# 🎓 School Management System

Une application complète de gestion scolaire développée avec Flutter et Firebase, utilisant l'architecture moderne avec Riverpod pour la gestion d'état.

## 📱 Aperçu

School Management System est une solution complète pour gérer les activités d'un établissement scolaire. L'application permet de gérer les étudiants, enseignants, classes, matières et bien plus encore avec une interface moderne et intuitive.

## ✨ Fonctionnalités

### 🔐 Authentification & Autorisation
- **Connexion sécurisée** avec Firebase Auth
- **Inscription** avec validation des données
- **Gestion des rôles** : Admin, Enseignant, Étudiant, Parent
- **Contrôle d'accès** basé sur les rôles
- **Réinitialisation de mot de passe**

### 👥 Gestion des Utilisateurs
- **Gestion des étudiants** : CRUD complet
- **Gestion des enseignants** : Profils et affectations
- **Gestion des classes** : Organisation par niveaux
- **Dashboard personnalisé** selon le rôle

### 📚 Gestion Académique
- **Matières/Cours** : Création et gestion des matières
- **Classes associées** : Liaison matières-classes
- **Départements** : Organisation par départements
- **Heures de crédit** : Gestion du volume horaire

### 🎯 Fonctionnalités Techniques
- **État réactif** avec Riverpod
- **Navigation moderne** avec Go Router
- **Base de données temps réel** avec Firestore
- **Support multi-plateforme** (Android, iOS, Web)
- **Mode hors ligne** partiellement supporté

## 🏗️ Architecture

L'application suit une architecture **Clean Architecture** avec séparation claire des responsabilités :

```
lib/
├── core/                          # Fonctionnalités communes
│   ├── providers/                 # Providers Riverpod globaux
│   ├── router/                    # Configuration Go Router
│   └── utils/                     # Utilitaires (Firebase, etc.)
├── features/                      # Fonctionnalités par domaine
│   ├── auth/                      # Authentification
│   │   ├── data/
│   │   │   ├── models/           # Modèles de données
│   │   │   └── repositories/     # Implémentation repositories
│   │   ├── domain/
│   │   │   └── repositories/     # Interfaces repositories
│   │   └── presentation/
│   │       └── screens/          # Écrans UI
│   ├── classes/                   # Gestion des classes
│   ├── courses/                   # Gestion des matières
│   ├── dashboard/                 # Tableau de bord
│   ├── students/                  # Gestion des étudiants
│   └── teachers/                  # Gestion des enseignants
├── scripts/                       # Scripts utilitaires
└── shared/                        # Composants partagés
```

## 🛠️ Technologies Utilisées

### Frontend
- **Flutter** 3.9.2+ - Framework UI cross-platform
- **Dart** - Langage de programmation
- **Material Design** - Design system Google

### State Management
- **Riverpod** 3.0.3+ - Gestion d'état réactive
- **Go Router** 16.2.5+ - Navigation déclarative

### Backend & Services
- **Firebase Auth** - Authentification
- **Cloud Firestore** - Base de données NoSQL
- **Firebase Storage** - Stockage de fichiers
- **Firebase Emulator** - Développement local

### Outils & Qualité
- **fpdart** - Programmation fonctionnelle
- **Google Fonts** - Typographie
- **Flutter Lints** - Analyse statique du code

## 🚀 Installation & Configuration

### Prérequis

- **Flutter SDK** 3.9.2 ou supérieur
- **Dart SDK** 3.0+
- **Firebase CLI** installé
- **Android Studio** / **VS Code** avec extensions Flutter
- **Émulateur Android** ou **appareil physique**

### Installation

1. **Cloner le repository**
```bash
git clone https://github.com/epiphane-gedeon/test_firebase.git
cd test_firebase
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration Firebase**
```bash
# Démarrer les émulateurs Firebase (pour le développement)
firebase emulators:start
```

4. **Lancer l'application**
```bash
# Mode développement avec émulateurs
flutter run

# ou spécifier un device
flutter run -d chrome  # Pour le web
flutter run -d android # Pour Android
```

### Configuration Firebase Production

Pour une utilisation en production, configurez Firebase :

1. Créer un projet Firebase
2. Ajouter les applications (Android/iOS/Web)
3. Télécharger les fichiers de configuration :
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
   - Config web Firebase

## 🔧 Variables d'Environnement

### Émulateur Firebase (Développement)

L'application est configurée pour utiliser automatiquement les émulateurs Firebase en mode debug :

- **Firestore** : `localhost:8080` (Web) / `10.0.2.2:8080` (Android)
- **Auth** : `localhost:9099` (Web) / `10.0.2.2:9099` (Android)
- **Storage** : `localhost:9199` (Web) / `10.0.2.2:9199` (Android)

### Production

Modifier `lib/core/utils/firebase_emulator.dart` pour désactiver les émulateurs en production.

## 💾 Base de Données

### Structure Firestore

```
users/                             # Collection des utilisateurs
├── {userId}/
│   ├── uid: string
│   ├── email: string
│   ├── displayName: string
│   ├── role: enum (admin|teacher|student|parent)
│   ├── createdAt: timestamp
│   └── isEmailVerified: boolean

classes/                           # Collection des classes
├── {classId}/
│   ├── name: string
│   ├── grade: string
│   ├── section: string
│   ├── maxStudents: number
│   └── createdAt: timestamp

subjects/                          # Collection des matières
├── {subjectId}/
│   ├── name: string
│   ├── description: string
│   ├── department: string
│   ├── creditHours: number
│   └── prerequisiteIds: array

teachers/                          # Collection des enseignants
students/                          # Collection des étudiants
```

### Seeding des Données

L'application inclut un système de seeding automatique pour les données de test :

```dart
// Exécuter le seeding
await SeedEmulator.run();
```

Cela crée automatiquement :
- 5 classes de test
- 5 enseignants
- 25 étudiants
- 14 matières dans différents départements

## 🧪 Tests

### Lancer les tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Analyse statique
flutter analyze

# Formatage du code
flutter format .
```

### Comptes de Test

Utilisez ces comptes pour tester l'application :

| Rôle | Email | Mot de passe | Description |
|------|-------|--------------|-------------|
| Admin | admin@school.com | password123 | Accès complet |
| Enseignant | teacher@school.com | password123 | Gestion des cours |
| Étudiant | student@school.com | password123 | Vue étudiant |

## 📱 Captures d'Écran

### Authentification
- Écran de connexion avec validation
- Inscription avec sélection de rôle
- Gestion des erreurs

### Dashboard
- Interface différenciée par rôle
- Accès rapide aux fonctionnalités
- Statistiques en temps réel

### Gestion des Matières
- Interface moderne avec cards
- Recherche et filtrage
- Association avec les classes

## 🤝 Contribution

### Guidelines

1. **Fork** le repository
2. **Créer une branche** pour votre fonctionnalité
3. **Commit** vos changements
4. **Push** vers votre branche
5. **Ouvrir une Pull Request**

### Conventions de Code

- Utiliser **dart format** pour le formatage
- Suivre les **Flutter style guidelines**
- Commenter les fonctions complexes
- Écrire des tests pour les nouvelles fonctionnalités

### Architecture Guidelines

- Respecter la **Clean Architecture**
- Utiliser **Riverpod** pour la gestion d'état
- Séparer **logique métier** et **UI**
- Implémenter le **Repository Pattern**

## 📄 Documentation

### Documentation Technique

- [Auth Providers Documentation](lib/core/providers/README_AUTH_PROVIDERS.md)
- [Architecture Guide](docs/ARCHITECTURE.md) *(à créer)*
- [Firebase Setup](docs/FIREBASE_SETUP.md) *(à créer)*

### Ressources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Go Router Documentation](https://pub.dev/packages/go_router)

## 🐛 Problèmes Connus

### Limitations Actuelles

- **Mode hors ligne** : Support partiel uniquement
- **Notifications push** : Non implémentées
- **Export de données** : En cours de développement
- **Interface parent** : Fonctionnalités basiques

### Issues GitHub

Consultez les [Issues GitHub](https://github.com/epiphane-gedeon/test_firebase/issues) pour :
- Signaler des bugs
- Demander des fonctionnalités
- Voir les problèmes connus

## 📞 Support

### Contact

- **Développeur** : Epiphane Gedeon
- **Email** : [votre-email@example.com]
- **GitHub** : [@epiphane-gedeon](https://github.com/epiphane-gedeon)

### Community

- **Discord** : [Lien vers serveur Discord] *(si applicable)*
- **Discussions** : [GitHub Discussions](https://github.com/epiphane-gedeon/test_firebase/discussions)

## 📋 Roadmap

### Version 1.0 (Actuelle)
- ✅ Authentification complète
- ✅ Gestion des utilisateurs
- ✅ Gestion des matières
- ✅ Interface de base

### Version 1.1 (Prochaine)
- 📅 Gestion des emplois du temps
- 📊 Système de notes
- 📱 Notifications push
- 🌐 Mode hors ligne amélioré

### Version 2.0 (Future)
- 💬 Système de messagerie
- 📚 Bibliothèque numérique
- 🎯 Analytics avancés
- 🔄 Synchronisation multi-établissements

## ⚖️ Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- **Flutter Team** pour le framework exceptionnel
- **Firebase Team** pour les services backend
- **Riverpod Community** pour la gestion d'état
- **Contributors** qui ont participé au projet

---

<div align="center">

**Fait avec ❤️ par l'équipe School Management**

[⭐ Star ce repo](https://github.com/epiphane-gedeon/test_firebase) • [🐛 Reporter un bug](https://github.com/epiphane-gedeon/test_firebase/issues) • [💡 Demander une fonctionnalité](https://github.com/epiphane-gedeon/test_firebase/issues)

</div>

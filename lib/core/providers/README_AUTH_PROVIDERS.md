# Auth Providers Documentation

Ce fichier contient tous les providers Riverpod pour gérer l'authentification dans l'application School Management.

## 📋 Vue d'ensemble

Les providers d'authentification offrent une interface complète pour :
- Gérer l'état de connexion des utilisateurs
- Effectuer les opérations CRUD d'authentification (connexion, inscription, déconnexion)
- Vérifier les rôles et permissions des utilisateurs
- Gérer les erreurs d'authentification de manière centralisée

## 🛠️ Providers disponibles

### Providers de base

#### `firebaseAuthProvider`
```dart
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
```
- **Type**: `Provider<FirebaseAuth>`
- **Utilisation**: Fournit l'instance Firebase Auth

#### `firestoreProvider`
```dart
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
```
- **Type**: `Provider<FirebaseFirestore>`
- **Utilisation**: Fournit l'instance Firestore

#### `authRepositoryProvider`
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
  );
});
```
- **Type**: `Provider<AuthRepository>`
- **Utilisation**: Fournit l'implémentation du repository d'authentification

### Providers d'état utilisateur

#### `authStateProvider` / `userStreamProvider`
```dart
final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.read(authRepositoryProvider).user;
});

final userStreamProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.user;
});
```
- **Type**: `StreamProvider<UserModel?>`
- **Utilisation**: Stream en temps réel de l'utilisateur connecté
- **Valeur**: `UserModel` si connecté, `null` sinon

#### `currentUserProvider`
```dart
final currentUserProvider = Provider<UserModel?>((ref) {
  final auth = ref.watch(authStateProvider);
  return auth.asData?.value;
});
```
- **Type**: `Provider<UserModel?>`
- **Utilisation**: Obtenir l'utilisateur connecté (synchrone)

#### `isUserLoggedInProvider`
```dart
final isUserLoggedInProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(userStreamProvider);
  return userAsync.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});
```
- **Type**: `Provider<bool>`
- **Utilisation**: Vérifier si un utilisateur est connecté

### Providers de rôles

#### `currentUserRoleProvider`
```dart
final currentUserRoleProvider = Provider<UserRole?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role;
});
```
- **Type**: `Provider<UserRole?>`
- **Utilisation**: Obtenir le rôle de l'utilisateur connecté

#### Providers de vérification de rôles
```dart
final isAdminProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.admin;
});

final isTeacherProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.teacher;
});

final isStudentProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.student;
});

final isParentProvider = Provider<bool>((ref) {
  final userRole = ref.watch(currentUserRoleProvider);
  return userRole == UserRole.parent;
});
```
- **Type**: `Provider<bool>`
- **Utilisation**: Vérifier si l'utilisateur a un rôle spécifique

### Providers d'actions

#### `signInProvider`
```dart
final signInProvider = FutureProvider.family<UserModel, SignInParams>((
  ref,
  params,
) async {
  // Logique de connexion
});
```
- **Type**: `FutureProvider.family<UserModel, SignInParams>`
- **Paramètres**: `SignInParams(email: String, password: String)`
- **Utilisation**: Connecter un utilisateur

#### `registerProvider`
```dart
final registerProvider = FutureProvider.family<UserModel, RegisterParams>((
  ref,
  params,
) async {
  // Logique d'inscription
});
```
- **Type**: `FutureProvider.family<UserModel, RegisterParams>`
- **Paramètres**: `RegisterParams(email: String, password: String, displayName: String, role: UserRole)`
- **Utilisation**: Créer un nouveau compte

#### `signOutProvider`
```dart
final signOutProvider = FutureProvider<void>((ref) async {
  // Logique de déconnexion
});
```
- **Type**: `FutureProvider<void>`
- **Utilisation**: Déconnecter l'utilisateur

#### `resetPasswordProvider`
```dart
final resetPasswordProvider = FutureProvider.family<void, String>((
  ref,
  email,
) async {
  // Logique de réinitialisation du mot de passe
});
```
- **Type**: `FutureProvider.family<void, String>`
- **Paramètres**: `String email`
- **Utilisation**: Envoyer un email de réinitialisation du mot de passe

### Contrôleur principal

#### `authControllerProvider`
```dart
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});
```
- **Type**: `Provider<AuthController>`
- **Utilisation**: Interface simplifiée pour toutes les actions d'authentification

## 🚀 Exemples d'utilisation

### 1. Vérifier si un utilisateur est connecté

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isUserLoggedInProvider);
    
    return isLoggedIn 
      ? DashboardScreen() 
      : LoginScreen();
  }
}
```

### 2. Afficher des informations utilisateur

```dart
class UserProfileWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return Text('Non connecté');
    }
    
    return Column(
      children: [
        Text('Nom: ${user.displayName}'),
        Text('Email: ${user.email}'),
        Text('Rôle: ${user.role.name}'),
      ],
    );
  }
}
```

### 3. Contrôle d'accès basé sur les rôles

```dart
class AdminPanelWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    
    if (!isAdmin) {
      return Text('Accès refusé');
    }
    
    return AdminPanel();
  }
}
```

### 4. Connexion d'un utilisateur

```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final authController = ref.read(authControllerProvider);
      await authController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Succès - la navigation est automatique
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie!')),
      );
    } catch (e) {
      // Gestion d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController),
          ElevatedButton(
            onPressed: _login,
            child: Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}
```

### 5. Déconnexion

```dart
class LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final authController = ref.read(authControllerProvider);
          await authController.signOut();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Déconnexion réussie')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${e.toString()}')),
          );
        }
      },
      child: Text('Se déconnecter'),
    );
  }
}
```

### 6. Écouter les changements d'état d'authentification

```dart
class AuthListener extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);
    
    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erreur: $error'),
      data: (user) {
        if (user == null) {
          return LoginScreen();
        }
        
        // Redirection basée sur le rôle
        switch (user.role) {
          case UserRole.admin:
            return AdminDashboard();
          case UserRole.teacher:
            return TeacherDashboard();
          case UserRole.student:
            return StudentDashboard();
          case UserRole.parent:
            return ParentDashboard();
        }
      },
    );
  }
}
```

## 🔧 Gestion d'erreurs

Toutes les méthodes du `AuthController` lancent des exceptions en cas d'erreur :

```dart
try {
  await authController.signIn(email: email, password: password);
} catch (e) {
  // e.toString() contient le message d'erreur
  print('Erreur de connexion: $e');
}
```

## 📝 Classes utilitaires

### `SignInParams`
```dart
class SignInParams {
  final String email;
  final String password;
  
  SignInParams({required this.email, required this.password});
}
```

### `RegisterParams`
```dart
class RegisterParams {
  final String email;
  final String password;
  final String displayName;
  final UserRole role;
  
  RegisterParams({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });
}
```

### `AuthController`
Classe utilitaire qui simplifie l'utilisation des providers d'authentification :

```dart
class AuthController {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> register({required String email, required String password, required String displayName, required UserRole role});
  Future<void> signOut();
  Future<void> resetPassword(String email);
}
```

## 🎯 Bonnes pratiques

1. **Utilisez `ConsumerWidget` ou `ConsumerStatefulWidget`** pour accéder aux providers
2. **Utilisez `ref.watch()`** pour les données qui changent l'UI
3. **Utilisez `ref.read()`** pour les actions et les méthodes
4. **Gérez toujours les erreurs** avec try-catch lors des opérations d'authentification
5. **Vérifiez `mounted`** avant d'afficher des SnackBars dans les widgets StatefulWidget
6. **Utilisez les providers de rôles** plutôt que de vérifier manuellement `user.role`

## 🔄 Flux d'authentification

1. L'utilisateur saisit ses identifiants
2. Appel de `authController.signIn()`
3. Le repository effectue la connexion Firebase
4. `userStreamProvider` se met à jour automatiquement
5. Tous les widgets qui écoutent cet état se reconstruisent
6. La navigation se fait automatiquement via le router

Ce système offre une gestion d'état réactive et centralisée pour toute l'authentification de l'application.
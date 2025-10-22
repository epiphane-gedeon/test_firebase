enum UserRole {
  admin,
  teacher,
  student,
  parent,
}

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    required this.role,
    required this.createdAt,
    this.lastLoginAt,
    required this.isEmailVerified,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'isEmailVerified': isEmailVerified,
    };
  }

  // Create from Firestore Document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.student,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'])
          : null,
      isEmailVerified: map['isEmailVerified'] ?? false,
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? email,
    String? displayName,
    UserRole? role,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
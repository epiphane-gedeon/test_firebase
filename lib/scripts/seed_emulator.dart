import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../features/auth/data/models/user_model.dart';
import '../features/students/data/models/student_model.dart';
import '../features/teachers/data/models/teacher_model.dart';
import '../features/classes/data/models/class_model.dart';
import 'subject_seeder.dart';

class EmulatorSeeder {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  EmulatorSeeder({required this.firestore, required this.auth});

  Future<void> seed() async {
    debugPrint('🌱 Début du seed des données de test...');

    try {
      // Créer les utilisateurs de test
      await _createTestUsers();

      // Créer les classes d'exemple
      await _createTestClasses();

      // Créer les enseignants d'exemple
      await _createTestTeachers();

      // Créer les élèves d'exemple
      await _createTestStudents();

      // Créer les matières d'exemple
      await SubjectSeeder.seedSubjects();

      debugPrint('✅ Seed terminé avec succès !');
    } catch (e) {
      debugPrint('❌ Erreur lors du seed: $e');
    }
  }

  Future<void> _createTestUsers() async {
    final users = [
      {
        'email': 'admin@school.com',
        'password': 'password123',
        'displayName': 'Admin Principal',
        'role': UserRole.admin,
      },
      {
        'email': 'teacher@school.com',
        'password': 'password123',
        'displayName': 'Professeur Dupont',
        'role': UserRole.teacher,
      },
      {
        'email': 'student@school.com',
        'password': 'password123',
        'displayName': 'Élève Martin',
        'role': UserRole.student,
      },
    ];

    for (final userData in users) {
      try {
        // Créer l'utilisateur Firebase Auth
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: userData['email'] as String,
          password: userData['password'] as String,
        );

        // Créer le document utilisateur dans Firestore
        final user = UserModel(
          uid: userCredential.user!.uid,
          email: userData['email'] as String,
          displayName: userData['displayName'] as String,
          role: userData['role'] as UserRole,
          createdAt: DateTime.now(),
          isEmailVerified: true,
        );

        await firestore.collection('users').doc(user.uid).set(user.toMap());

        debugPrint('✅ Utilisateur créé: ${user.email}');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          debugPrint('ℹ️ Utilisateur déjà existant: ${userData['email']}');
        } else {
          debugPrint('❌ Erreur création utilisateur ${userData['email']}: $e');
        }
      }
    }
  }

  Future<void> _createTestClasses() async {
    debugPrint('📚 Création des classes de test...');

    final classes = [
      ClassModel(
        id: 'class_6a',
        name: '6ème A',
        grade: '6ème',
        academicYear: DateTime.now().year,
        maxStudents: 25,
      ),
      ClassModel(
        id: 'class_6b',
        name: '6ème B',
        grade: '6ème',
        academicYear: DateTime.now().year,
        maxStudents: 25,
      ),
      ClassModel(
        id: 'class_5a',
        name: '5ème A',
        grade: '5ème',
        academicYear: DateTime.now().year,
        maxStudents: 28,
      ),
      ClassModel(
        id: 'class_4a',
        name: '4ème A',
        grade: '4ème',
        academicYear: DateTime.now().year,
        maxStudents: 30,
      ),
      ClassModel(
        id: 'class_3a',
        name: '3ème A',
        grade: '3ème',
        academicYear: DateTime.now().year,
        maxStudents: 30,
      ),
    ];

    for (final classData in classes) {
      try {
        final doc = await firestore
            .collection('classes')
            .doc(classData.id)
            .get();
        if (!doc.exists) {
          await firestore
              .collection('classes')
              .doc(classData.id)
              .set(classData.toMap());
          debugPrint('✅ Classe créée: ${classData.name}');
        } else {
          debugPrint('ℹ️ Classe déjà existante: ${classData.name}');
        }
      } catch (e) {
        debugPrint('❌ Erreur création classe ${classData.name}: $e');
      }
    }
  }

  Future<void> _createTestTeachers() async {
    debugPrint('👨‍🏫 Création des enseignants de test...');

    final teachers = [
      {
        'firstName': 'Marie',
        'lastName': 'Dupont',
        'email': 'marie.dupont@school.com',
        'department': 'Mathématiques',
        'office': 'B101',
        'phone': '01.23.45.67.89',
      },
      {
        'firstName': 'Jean',
        'lastName': 'Martin',
        'email': 'jean.martin@school.com',
        'department': 'Français',
        'office': 'A205',
        'phone': '01.23.45.67.90',
      },
      {
        'firstName': 'Sophie',
        'lastName': 'Bernard',
        'email': 'sophie.bernard@school.com',
        'department': 'Histoire-Géographie',
        'office': 'C102',
        'phone': '01.23.45.67.91',
      },
      {
        'firstName': 'Pierre',
        'lastName': 'Moreau',
        'email': 'pierre.moreau@school.com',
        'department': 'Sciences',
        'office': 'D301',
        'phone': '01.23.45.67.92',
      },
      {
        'firstName': 'Amélie',
        'lastName': 'Dubois',
        'email': 'amelie.dubois@school.com',
        'department': 'Anglais',
        'office': 'B203',
        'phone': '01.23.45.67.93',
      },
    ];

    for (int i = 0; i < teachers.length; i++) {
      try {
        final teacherData = teachers[i];
        final teacherId = 'teacher_${i + 1}';

        // Créer un utilisateur Firebase Auth pour l'enseignant
        UserCredential? userCredential;
        try {
          userCredential = await auth.createUserWithEmailAndPassword(
            email: teacherData['email']!,
            password: 'password123',
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            debugPrint(
              'ℹ️ Utilisateur Auth déjà existant: ${teacherData['email']}',
            );
            // On continue avec l'utilisateur existant
          }
        }

        final doc = await firestore.collection('teachers').doc(teacherId).get();
        if (!doc.exists) {
          final teacher = TeacherModel(
            id: teacherId,
            userId: userCredential?.user?.uid ?? 'temp_uid_$i',
            firstName: teacherData['firstName']!,
            lastName: teacherData['lastName']!,
            email: teacherData['email']!,
            phoneNumber: teacherData['phone'],
            department: teacherData['department'],
            office: teacherData['office'],
            hireDate: DateTime.now().subtract(Duration(days: 365 * (i + 1))),
          );

          await firestore
              .collection('teachers')
              .doc(teacherId)
              .set(teacher.toMap());
          debugPrint('✅ Enseignant créé: ${teacher.fullName}');

          // Créer aussi le document user si un utilisateur Auth a été créé
          if (userCredential?.user != null) {
            final userModel = UserModel(
              uid: userCredential!.user!.uid,
              email: teacherData['email']!,
              displayName:
                  '${teacherData['firstName']} ${teacherData['lastName']}',
              role: UserRole.teacher,
              createdAt: DateTime.now(),
              isEmailVerified: true,
            );
            await firestore
                .collection('users')
                .doc(userModel.uid)
                .set(userModel.toMap());
          }
        } else {
          debugPrint(
            'ℹ️ Enseignant déjà existant: ${teacherData['firstName']} ${teacherData['lastName']}',
          );
        }
      } catch (e) {
        debugPrint(
          '❌ Erreur création enseignant ${teachers[i]['firstName']} ${teachers[i]['lastName']}: $e',
        );
      }
    }
  }

  Future<void> _createTestStudents() async {
    debugPrint('👨‍🎓 Création des élèves de test...');

    final students = [
      // Élèves de 6ème A
      {
        'firstName': 'Lucas',
        'lastName': 'Petit',
        'classId': 'class_6a',
        'grade': '6ème',
        'parentEmail': 'parent.lucas@email.com',
      },
      {
        'firstName': 'Emma',
        'lastName': 'Garcia',
        'classId': 'class_6a',
        'grade': '6ème',
        'parentEmail': 'parent.emma@email.com',
      },
      {
        'firstName': 'Noah',
        'lastName': 'Roux',
        'classId': 'class_6a',
        'grade': '6ème',
        'parentEmail': 'parent.noah@email.com',
      },
      {
        'firstName': 'Léa',
        'lastName': 'Fournier',
        'classId': 'class_6a',
        'grade': '6ème',
        'parentEmail': 'parent.lea@email.com',
      },
      {
        'firstName': 'Louis',
        'lastName': 'Girard',
        'classId': 'class_6a',
        'grade': '6ème',
        'parentEmail': 'parent.louis@email.com',
      },

      // Élèves de 6ème B
      {
        'firstName': 'Chloé',
        'lastName': 'André',
        'classId': 'class_6b',
        'grade': '6ème',
        'parentEmail': 'parent.chloe@email.com',
      },
      {
        'firstName': 'Hugo',
        'lastName': 'Lefebvre',
        'classId': 'class_6b',
        'grade': '6ème',
        'parentEmail': 'parent.hugo@email.com',
      },
      {
        'firstName': 'Manon',
        'lastName': 'Simon',
        'classId': 'class_6b',
        'grade': '6ème',
        'parentEmail': 'parent.manon@email.com',
      },
      {
        'firstName': 'Enzo',
        'lastName': 'Michel',
        'classId': 'class_6b',
        'grade': '6ème',
        'parentEmail': 'parent.enzo@email.com',
      },
      {
        'firstName': 'Jade',
        'lastName': 'Laurent',
        'classId': 'class_6b',
        'grade': '6ème',
        'parentEmail': 'parent.jade@email.com',
      },

      // Élèves de 5ème A
      {
        'firstName': 'Théo',
        'lastName': 'Leroy',
        'classId': 'class_5a',
        'grade': '5ème',
        'parentEmail': 'parent.theo@email.com',
      },
      {
        'firstName': 'Camille',
        'lastName': 'Moreau',
        'classId': 'class_5a',
        'grade': '5ème',
        'parentEmail': 'parent.camille@email.com',
      },
      {
        'firstName': 'Maxime',
        'lastName': 'Blanchard',
        'classId': 'class_5a',
        'grade': '5ème',
        'parentEmail': 'parent.maxime@email.com',
      },
      {
        'firstName': 'Inès',
        'lastName': 'Gauthier',
        'classId': 'class_5a',
        'grade': '5ème',
        'parentEmail': 'parent.ines@email.com',
      },
      {
        'firstName': 'Arthur',
        'lastName': 'Rousseau',
        'classId': 'class_5a',
        'grade': '5ème',
        'parentEmail': 'parent.arthur@email.com',
      },

      // Élèves de 4ème A
      {
        'firstName': 'Sarah',
        'lastName': 'Caron',
        'classId': 'class_4a',
        'grade': '4ème',
        'parentEmail': 'parent.sarah@email.com',
      },
      {
        'firstName': 'Nathan',
        'lastName': 'Guerin',
        'classId': 'class_4a',
        'grade': '4ème',
        'parentEmail': 'parent.nathan@email.com',
      },
      {
        'firstName': 'Clara',
        'lastName': 'Barbier',
        'classId': 'class_4a',
        'grade': '4ème',
        'parentEmail': 'parent.clara@email.com',
      },
      {
        'firstName': 'Tom',
        'lastName': 'Brun',
        'classId': 'class_4a',
        'grade': '4ème',
        'parentEmail': 'parent.tom@email.com',
      },
      {
        'firstName': 'Lola',
        'lastName': 'Giraud',
        'classId': 'class_4a',
        'grade': '4ème',
        'parentEmail': 'parent.lola@email.com',
      },

      // Élèves de 3ème A
      {
        'firstName': 'Antoine',
        'lastName': 'Fabre',
        'classId': 'class_3a',
        'grade': '3ème',
        'parentEmail': 'parent.antoine@email.com',
      },
      {
        'firstName': 'Marine',
        'lastName': 'Perrin',
        'classId': 'class_3a',
        'grade': '3ème',
        'parentEmail': 'parent.marine@email.com',
      },
      {
        'firstName': 'Julien',
        'lastName': 'Robin',
        'classId': 'class_3a',
        'grade': '3ème',
        'parentEmail': 'parent.julien@email.com',
      },
      {
        'firstName': 'Eva',
        'lastName': 'Clement',
        'classId': 'class_3a',
        'grade': '3ème',
        'parentEmail': 'parent.eva@email.com',
      },
      {
        'firstName': 'Romain',
        'lastName': 'Morel',
        'classId': 'class_3a',
        'grade': '3ème',
        'parentEmail': 'parent.romain@email.com',
      },
    ];

    for (int i = 0; i < students.length; i++) {
      try {
        final studentData = students[i];
        final studentId = 'student_${i + 1}';

        // Créer un utilisateur Firebase Auth pour l'élève
        final studentEmail =
            '${studentData['firstName']!.toLowerCase()}.${studentData['lastName']!.toLowerCase()}@school.com';
        UserCredential? userCredential;
        try {
          userCredential = await auth.createUserWithEmailAndPassword(
            email: studentEmail,
            password: 'password123',
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            debugPrint('ℹ️ Utilisateur Auth déjà existant: $studentEmail');
          }
        }

        final doc = await firestore.collection('students').doc(studentId).get();
        if (!doc.exists) {
          final student = StudentModel(
            id: studentId,
            userId: userCredential?.user?.uid ?? 'temp_uid_student_$i',
            firstName: studentData['firstName']!,
            lastName: studentData['lastName']!,
            parentEmail: studentData['parentEmail'],
            classId: studentData['classId']!,
            enrollmentDate: DateTime.now().subtract(Duration(days: 30 * i)),
            dateOfBirth: DateTime(
              2010 - int.parse(studentData['grade']![0]),
              6,
              15 + (i % 20),
            ),
            address: '${i + 1} Rue des Écoles, 75000 Paris',
            phoneNumber:
                '0${6 + (i % 3)}.${(12 + i).toString().padLeft(2, '0')}.${(34 + i).toString().padLeft(2, '0')}.${(56 + i).toString().padLeft(2, '0')}.${(78 + i).toString().padLeft(2, '0')}',
          );

          await firestore
              .collection('students')
              .doc(studentId)
              .set(student.toMap());
          debugPrint(
            '✅ Élève créé: ${student.fullName} (${studentData['classId']})',
          );

          // Créer aussi le document user si un utilisateur Auth a été créé
          if (userCredential?.user != null) {
            final userModel = UserModel(
              uid: userCredential!.user!.uid,
              email: studentEmail,
              displayName:
                  '${studentData['firstName']} ${studentData['lastName']}',
              role: UserRole.student,
              createdAt: DateTime.now(),
              isEmailVerified: true,
            );
            await firestore
                .collection('users')
                .doc(userModel.uid)
                .set(userModel.toMap());
          }

          // Mettre à jour la classe pour ajouter l'élève
          await _addStudentToClass(studentData['classId']!, studentId);
        } else {
          debugPrint(
            'ℹ️ Élève déjà existant: ${studentData['firstName']} ${studentData['lastName']}',
          );
        }
      } catch (e) {
        debugPrint(
          '❌ Erreur création élève ${students[i]['firstName']} ${students[i]['lastName']}: $e',
        );
      }
    }
  }

  Future<void> _addStudentToClass(String classId, String studentId) async {
    try {
      final classDoc = await firestore.collection('classes').doc(classId).get();
      if (classDoc.exists) {
        final classData = ClassModel.fromMap(classDoc.data()!);
        if (!classData.studentIds.contains(studentId)) {
          final updatedStudentIds = [...classData.studentIds, studentId];
          await firestore.collection('classes').doc(classId).update({
            'studentIds': updatedStudentIds,
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur ajout élève à la classe $classId: $e');
    }
  }
}

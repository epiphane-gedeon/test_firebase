import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/students/presentation/screens/student_list_screen.dart';
import '../../features/students/presentation/screens/student_detail_screen.dart';
import '../../features/students/presentation/screens/add_edit_student_screen.dart';
import '../../features/students/presentation/screens/edit_student_screen.dart';
import '../../features/classes/presentation/screens/class_list_screen.dart';
import '../../features/classes/presentation/screens/class_detail_screen.dart';
import '../../features/classes/presentation/screens/add_edit_class_screen.dart';
import '../../features/teachers/presentation/screens/teacher_list_screen.dart';
import '../../features/teachers/presentation/screens/teacher_detail_screen.dart';
import '../../features/teachers/presentation/screens/add_edit_teacher_screen.dart';
import '../../features/courses/presentation/screens/subject_list_screen.dart';
import '../../features/courses/presentation/screens/subject_detail_screen.dart';
import '../../features/courses/presentation/screens/add_edit_subject_screen.dart';

class AppRoutes {
  // Routes de base
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';

  static const students = '/dashboard/students';
  static String studentDetail(String id) => '/dashboard/students/$id';
  static const classes = '/dashboard/classes';
  static String classDetail(String id) => '/dashboard/classes/$id';
  static const teachers = '/dashboard/teachers';
  static String teacherDetail(String id) => '/dashboard/teachers/$id';
  static const subjects = '/dashboard/subjects';
  static String subjectDetail(String id) => '/dashboard/subjects/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Routes publiques
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Dashboard principal
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // Routes étudiants (gardons la structure simple pour l'instant)
          GoRoute(
            path: 'students',
            name: 'students',
            builder: (context, state) => const StudentListScreen(),
          ),
          GoRoute(
            path: 'students/add',
            name: 'add_student',
            builder: (context, state) => const AddEditStudentScreen(),
          ),
          GoRoute(
            path:
                'students/edit/:id', // ← Chemin relatif: /dashboard/students/edit/:id
            name: 'edit_student',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EditStudentScreen(id: id);
            },
          ),
          GoRoute(
            path: 'students/:id',
            name: 'student_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StudentDetailScreen(id: id);
            },
          ),

          // Classes routes
          GoRoute(
            path: 'classes', // ← Chemin relatif: /dashboard/classes
            name: 'classes',
            builder: (context, state) => const ClassListScreen(),
          ),

          GoRoute(
            path: 'classes/add', // ← Chemin relatif: /dashboard/classes/add
            name: 'add_class',
            builder: (context, state) => const AddEditClassScreen(),
          ),

          GoRoute(
            path:
                'classes/edit/:id', // ← Chemin relatif: /dashboard/classes/edit/:id
            name: 'edit_class',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return AddEditClassScreen(classId: id);
            },
          ),

          GoRoute(
            path: 'classes/:id', // ← Chemin relatif: /dashboard/classes/:id
            name: 'class_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ClassDetailScreen(classId: id);
            },
          ),

          // Teachers routes
          GoRoute(
            path: 'teachers', // ← Chemin relatif: /dashboard/teachers
            name: 'teachers',
            builder: (context, state) => const TeacherListScreen(),
          ),

          GoRoute(
            path: 'teachers/add', // ← Chemin relatif: /dashboard/teachers/add
            name: 'add_teacher',
            builder: (context, state) => const AddEditTeacherScreen(),
          ),

          GoRoute(
            path:
                'teachers/edit/:id', // ← Chemin relatif: /dashboard/teachers/edit/:id
            name: 'edit_teacher',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return AddEditTeacherScreen(teacherId: id);
            },
          ),

          GoRoute(
            path: 'teachers/:id', // ← Chemin relatif: /dashboard/teachers/:id
            name: 'teacher_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TeacherDetailScreen(teacherId: id);
            },
          ),

          // Subjects routes (Matières)
          GoRoute(
            path: 'subjects', // ← Chemin relatif: /dashboard/subjects
            name: 'subjects',
            builder: (context, state) => const SubjectListScreen(),
          ),

          GoRoute(
            path: 'subjects/add', // ← Chemin relatif: /dashboard/subjects/add
            name: 'add_subject',
            builder: (context, state) => const AddEditSubjectScreen(),
          ),

          GoRoute(
            path:
                'subjects/edit/:id', // ← Chemin relatif: /dashboard/subjects/edit/:id
            name: 'edit_subject',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return AddEditSubjectScreen(subjectId: id);
            },
          ),

          GoRoute(
            path: 'subjects/:id', // ← Chemin relatif: /dashboard/subjects/:id
            name: 'subject_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return SubjectDetailScreen(subjectId: id);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isLogin = state.matchedLocation == AppRoutes.login;
      final isRegister = state.matchedLocation == AppRoutes.register;

      // Si on est sur le splash screen, on reste
      if (isSplash) return null;

      // Si non authentifié et pas sur login/register → rediriger vers login
      if (!isAuthenticated && !isLogin && !isRegister) return AppRoutes.login;

      // Si authentifié et sur login/register → rediriger vers dashboard
      if (isAuthenticated && (isLogin || isRegister)) {
        return AppRoutes.dashboard;
      }

      // Sinon, laisser passer
      return null;
    },
  );
});

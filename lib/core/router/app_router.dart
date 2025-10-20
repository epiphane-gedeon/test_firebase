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

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const students = '/dashboard/students';
  static String studentDetail(String id) => '/dashboard/students/$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
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
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // Students routes - Note: ces chemins sont RELATIFS à /dashboard
          GoRoute(
            path: 'students', // ← Chemin relatif:  /dashboard/students
            name: 'students',
            builder: (context, state) => const StudentListScreen(),
          ),

          GoRoute(
            path: 'students/add', // ← Chemin relatif: /dashboard/students/add
            name: 'add_student',
            builder: (context, state) => const AddEditStudentScreen(),
          ),

          GoRoute(
            path: 'students/edit/:id', // ← Chemin relatif: /dashboard/students/edit/:id
            name: 'edit_student',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EditStudentScreen(id: id);
            },
          ),

          GoRoute(
            path: 'students/:id', // ← Chemin relatif: /dashboard/students/:id
            name: 'student_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StudentDetailScreen(id: id);
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
      if (isAuthenticated && (isLogin || isRegister)) return AppRoutes.dashboard;

      // Sinon, laisser passer
      return null;
    },
  );
});
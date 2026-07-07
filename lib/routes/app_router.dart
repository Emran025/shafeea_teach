import 'package:go_router/go_router.dart';
import 'package:shafeea/features/auth/presentation/ui/screens/login_screen.dart';
import 'package:shafeea/features/app/pages/splash_screen.dart';
import 'package:shafeea/features/app/pages/welcome_screen.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/screens/admin_home_screen.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/screens/applicant_profile_screen.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/screens/teacher_home_screen.dart';
import 'package:shafeea/features/auth/presentation/ui/screens/verify_email_screen.dart';
import 'package:shafeea/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The main router configuration for the application.
///
/// This GoRouter instance handles all navigation logic, including authentication-based
/// redirects and the definition of all available routes.

// We need to listen to both streams now!
final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final bool loggedIn = authState.authStatus == AuthStatus.authenticated;
    final bool verifying = state.matchedLocation == '/verify_email';
    final bool isEmailVerified = authState.user?.isEmailVerified ?? false;

    if (!loggedIn) {
      // Not logged in: allow access only to public routes (login, welcome, splash)
      final bool publicRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/welcome' ||
          state.matchedLocation == '/splash';
      return publicRoute ? null : '/welcome';
    }

    // Logged in: check for email verification
    if (!isEmailVerified) {
       return verifying ? null : '/verify_email';
    }

    // Verified: don't allow access to verify_email or auth screens
    if (verifying || state.matchedLocation == '/login' || state.matchedLocation == '/welcome') {
      return '/home';
    }

    return null;
  },

  routes: [
    /// Defines the route for the splash screen, shown on app startup.
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),

    /// Defines the route for the welcome screen, the first screen for unauthenticated users.
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (_, __) => const WelcomeScreen(),
    ),

    /// Defines the route for the login screen.
    GoRoute(
      path: '/login', // Using snake_case for consistency
      name: 'login',
      builder: (_, __) => const LogInScreen(),
    ),

    /// Defines the route for the email verification screen.
    GoRoute(
      path: '/verify_email',
      name: 'verify_email',
      builder: (_, __) => const VerifyEmailScreen(),
    ),

    /// Defines the route for the main dashboard for supervisor users.
    GoRoute(
      path: '/home',
      name: 'home',
      // builder: (_, __) => const TecherDashboard(),
      builder: (_, __) => const SupervisorDashboard(),
    ),

    /// Defines the route for the main dashboard for teacher users.
    GoRoute(
      path: '/teacher_home',
      name: 'teacher_home',
      // Note: Ensure the class name 'TecherDashboard' is correct.
      // It might be a typo for 'TeacherDashboard'.
      // builder: (_, __) => const SupervisorDashboard(),
      builder: (_, __) => const TecherDashboard(),
    ),
    GoRoute(
      path: '/applicant_profile/:id',
      name: 'applicant_profile',
      builder: (context, state) {
        final applicantId = int.parse(state.pathParameters['id']!);
        return ApplicantProfileScreen(applicantId: applicantId);
      },
    ),
  ],
);

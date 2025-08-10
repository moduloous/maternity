import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/jobs/job_detail_screen.dart';
import '../screens/jobs/post_job_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/saved_jobs/saved_jobs_screen.dart';
import '../screens/applications/applications_screen.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: Provider.of<AuthProvider>(context, listen: false),
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isAuthenticated = authProvider.isAuthenticated;
        final isOnAuthRoute = state.matchedLocation.startsWith('/auth');
        final isOnSplash = state.matchedLocation == '/splash';
        
        print('Router redirect - Location: ${state.matchedLocation}, Authenticated: $isAuthenticated, User: ${authProvider.currentUser?.name}');
        
        // Allow splash screen to show
        if (isOnSplash) {
          return null;
        }
        
        // If user is authenticated and on auth route, redirect to home
        if (isAuthenticated && isOnAuthRoute) {
          print('Redirecting to home - authenticated');
          return '/home';
        }
        
        // If user is not authenticated and not on auth route, redirect to login
        if (!isAuthenticated && !isOnAuthRoute) {
          print('Redirecting to login - not authenticated');
          return '/auth/login';
        }
        
        // Allow access to current route
        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        
        // Auth Routes
        GoRoute(
          path: '/auth/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/auth/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        
        // Main App Routes
        GoRoute(
          path: '/',
          redirect: (context, state) => '/auth/login',
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/job/:id',
          name: 'job-detail',
          builder: (context, state) {
            final jobId = state.pathParameters['id']!;
            return JobDetailScreen(jobId: jobId);
          },
        ),
        GoRoute(
          path: '/post-job',
          name: 'post-job',
          builder: (context, state) => const PostJobScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/saved-jobs',
          name: 'saved-jobs',
          builder: (context, state) => const SavedJobsScreen(),
        ),
        GoRoute(
          path: '/applications',
          name: 'applications',
          builder: (context, state) => const ApplicationsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
        ),
        body: const Center(
          child: Text('The page you are looking for does not exist.'),
        ),
      ),
    );
  }
}

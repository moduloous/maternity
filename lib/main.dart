import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/supabase_config.dart';
import 'utils/theme.dart';
import 'utils/router.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/application_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show loading screen while initializing
          if (authProvider.isLoading) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          
          return MaterialApp.router(
            title: 'Maternity Jobs',
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.getRouter(context),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              print('MainApp: Building with auth state - ${authProvider.isAuthenticated}');
              return child!;
            },
          );
        },
      ),
    );
  }
}

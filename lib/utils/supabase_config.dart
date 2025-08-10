import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Supabase credentials
  static const String supabaseUrl = 'https://tdarvqbnuoloxndknqqq.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRkYXJ2cWJudW9sb3huZGtucXFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMyNTUwNzUsImV4cCI6MjA2ODgzMTA3NX0.SieUFya-_F6aqCpKChS0LO7dR-0O40YRZYX3xcedfc4';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  
  static User? get currentUser => client.auth.currentUser;
  
  static bool get isAuthenticated => currentUser != null;
}

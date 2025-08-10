import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../utils/supabase_config.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Sign up with email and password (no email verification)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
                 data: {
           'name': name,
           'role': _getRoleString(role),
         },
        emailRedirectTo: null, // Disable email verification
      );

      if (response.user != null) {
        print('Auth user created with ID: ${response.user!.id}');
        
        // Wait a moment for auth to complete
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Try multiple approaches to create profile
        bool profileCreated = false;
        
        // Approach 1: Direct insert
        try {
          final profileResponse = await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'name': name,
            'role': _getRoleString(role),
            'created_at': DateTime.now().toIso8601String(),
          }).select();
          
          print('Profile created successfully: $profileResponse');
          profileCreated = true;
        } catch (e) {
          print('Direct insert failed: $e');
        }
        
        // Approach 2: RPC function
        if (!profileCreated) {
          try {
                         await _supabase.rpc('create_user_profile', params: {
               'user_id': response.user!.id,
               'user_email': email,
               'user_name': name,
               'user_role': _getRoleString(role),
             });
            print('Profile created via RPC');
            profileCreated = true;
          } catch (rpcError) {
            print('RPC failed: $rpcError');
          }
        }
        
        // Approach 3: Manual SQL (as last resort)
        if (!profileCreated) {
          try {
            await _supabase.rpc('execute_sql', params: {
                             'sql': '''
                 INSERT INTO users (id, email, name, role, created_at)
                 VALUES ('${response.user!.id}', '$email', '$name', '${_getRoleString(role)}', NOW())
                 ON CONFLICT (id) DO NOTHING;
               '''
            });
            print('Profile created via manual SQL');
            profileCreated = true;
          } catch (sqlError) {
            print('Manual SQL failed: $sqlError');
          }
        }
        
        if (!profileCreated) {
          print('WARNING: Could not create user profile. User will need to be created manually.');
        }
      }

      return response;
    } catch (e) {
      print('Error in signUp: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    print('AuthService: Attempting sign in for email: $email');
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('AuthService: Sign in successful - user: ${response.user?.id}');
      return response;
    } catch (e) {
      print('AuthService: Sign in error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }



  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error getting user profile: $e');
      // If profile doesn't exist, try to get basic info from auth
      final user = _supabase.auth.currentUser;
      if (user != null && user.id == userId) {
        return UserModel(
          id: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] ?? 'Unknown',
          role: UserRole.jobSeeker, // Default role
          skills: [],
          experience: '',
          maternityStatus: false,
          resumeUrl: '',
          companyName: '',
          createdAt: DateTime.now(),
        );
      }
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _supabase
        .from('users')
        .update(data)
        .eq('id', userId);
  }

  // Stream auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Helper method to convert UserRole to database string
  String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.jobSeeker:
        return 'job_seeker';
      case UserRole.employer:
        return 'employer';
    }
  }
}

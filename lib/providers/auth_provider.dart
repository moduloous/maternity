import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Initialize auth state
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final user = _authService.currentUser;
      print('AuthProvider: Initializing with user: ${user?.id}');
      if (user != null) {
        _currentUser = await _authService.getUserProfile(user.id);
        print('AuthProvider: Loaded user profile: ${_currentUser?.name}');
        notifyListeners();
      }
    } catch (e) {
      print('AuthProvider: Initialization error: $e');
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      
      if (response.user != null) {
        // Wait a moment for the profile to be fully created
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Get the user profile
        _currentUser = await _authService.getUserProfile(response.user!.id);
        
        // If profile is still null, create a fallback user
        if (_currentUser == null) {
          _currentUser = UserModel(
            id: response.user!.id,
            email: email,
            name: name,
            role: role,
            skills: [],
            experience: '',
            maternityStatus: false,
            resumeUrl: '',
            companyName: '',
            createdAt: DateTime.now(),
          );
        }
        
        print('AuthProvider: User authenticated successfully - ${_currentUser?.name}');
        notifyListeners();
        return true;
      } else {
        _setError('Sign up failed');
        return false;
      }
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    print('AuthProvider: Attempting sign in for email: $email');
    
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      
      print('AuthProvider: Sign in response - user: ${response.user?.id}');
      
      if (response.user != null) {
        print('AuthProvider: User authenticated, loading profile...');
        _currentUser = await _authService.getUserProfile(response.user!.id);
        print('AuthProvider: Profile loaded - ${_currentUser?.name}');
        notifyListeners();
        return true;
      } else {
        print('AuthProvider: Sign in failed - no user in response');
        _setError('Sign in failed');
        return false;
      }
    } catch (e) {
      print('AuthProvider: Sign in error: $e');
      _setError('Sign in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed');
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }



  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.updateUserProfile(_currentUser!.id, data);
      _currentUser = await _authService.getUserProfile(_currentUser!.id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

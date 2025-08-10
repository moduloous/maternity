class AppConstants {
  // App Info
  static const String appName = 'Maternity Jobs';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (if needed for external APIs)
  static const String baseUrl = 'https://api.example.com';
  
  // Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String authTokenKey = 'auth_token';
  static const String savedJobsKey = 'saved_jobs';
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx'];
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 1000;
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String generalErrorMessage = 'Something went wrong. Please try again.';
  static const String invalidEmailMessage = 'Please enter a valid email address.';
  static const String weakPasswordMessage = 'Password must be at least 6 characters long.';
  static const String requiredFieldMessage = 'This field is required.';
  
  // Success Messages
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String jobPostedMessage = 'Job posted successfully!';
  static const String applicationSubmittedMessage = 'Application submitted successfully!';
  static const String passwordResetMessage = 'Password reset email sent!';
  
  // Job Types
  static const List<String> jobTypeLabels = [
    'Full Time',
    'Part Time',
    'Remote',
    'Contract',
  ];
  
  // User Roles
  static const List<String> userRoleLabels = [
    'Job Seeker',
    'Employer',
  ];
}

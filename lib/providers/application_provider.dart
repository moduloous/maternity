import 'package:flutter/material.dart';
import '../models/application_model.dart';
import '../services/application_service.dart';

class ApplicationProvider extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();
  
  List<ApplicationModel> _applications = [];
  bool _isLoading = false;
  String? _error;

  List<ApplicationModel> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Submit application
  Future<bool> submitApplication({
    String? jobId, // Made optional since we're using static job data
    required String applicantId,
    required String name,
    required String email,
    required String message,
    String? resumeUrl,
    String? jobTitle,
    String? companyName,
    String? location,
    String? salary,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final application = await _applicationService.submitApplication(
        jobId: jobId ?? '', // Pass empty string if null
        applicantId: applicantId,
        name: name,
        email: email,
        message: message,
        resumeUrl: resumeUrl,
        jobTitle: jobTitle,
        companyName: companyName,
        location: location,
        salary: salary,
      );
      
      if (application != null) {
        // Check if application already exists to prevent duplicates
        final existingIndex = _applications.indexWhere((app) => app.id == application.id);
        if (existingIndex == -1) {
          // Only add if it doesn't already exist
          _applications.insert(0, application);
          notifyListeners();
        }
        return true;
      } else {
        _setError('Failed to submit application');
        return false;
      }
    } catch (e) {
      _setError('Failed to submit application: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load applications for a job
  Future<void> loadApplicationsForJob(String jobId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _applications = await _applicationService.getApplicationsForJob(jobId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load applications: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load applications by applicant
  Future<void> loadApplicationsByApplicant(String applicantId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _applications = await _applicationService.getApplicationsByApplicant(applicantId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load applications: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load user applications (alias for loadApplicationsByApplicant)
  Future<void> loadUserApplications({String? userId}) async {
    if (userId != null) {
      await loadApplicationsByApplicant(userId);
    } else {
      // If no userId provided, we'll load empty list
      _applications = [];
      notifyListeners();
    }
  }

  // Delete application
  Future<bool> deleteApplication(String applicationId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _applicationService.deleteApplication(applicationId);
      
      if (success) {
        _applications.removeWhere((app) => app.id == applicationId);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete application');
        return false;
      }
    } catch (e) {
      _setError('Failed to delete application: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get application by ID
  ApplicationModel? getApplicationById(String applicationId) {
    try {
      return _applications.firstWhere((app) => app.id == applicationId);
    } catch (e) {
      return null;
    }
  }

  // Clear all applications (useful for ensuring only real submissions are shown)
  void clearApplications() {
    _applications.clear();
    _clearError();
    notifyListeners();
  }

  // Remove duplicate applications from the list
  void removeDuplicates() {
    final uniqueApplications = <String, ApplicationModel>{};
    for (final application in _applications) {
      uniqueApplications[application.id] = application;
    }
    _applications = uniqueApplications.values.toList();
    notifyListeners();
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

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
    required String jobId,
    required String applicantId,
    required String name,
    required String email,
    required String message,
    String? resumeUrl,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final application = await _applicationService.submitApplication(
        jobId: jobId,
        applicantId: applicantId,
        name: name,
        email: email,
        message: message,
        resumeUrl: resumeUrl,
      );
      
      if (application != null) {
        _applications.insert(0, application);
        notifyListeners();
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

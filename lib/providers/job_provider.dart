import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';

class JobProvider extends ChangeNotifier {
  final JobService _jobService = JobService();
  
  List<JobModel> _jobs = [];
  final List<JobModel> _savedJobs = [];
  bool _isLoading = false;
  String? _error;
  bool _maternityFriendlyFilter = false;

  List<JobModel> get jobs => _jobs;
  List<JobModel> get savedJobs => _savedJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get maternityFriendlyFilter => _maternityFriendlyFilter;

  // Load jobs
  Future<void> loadJobs({bool? maternityFriendly}) async {
    _setLoading(true);
    _clearError();
    
    try {
      _jobs = await _jobService.getJobs(maternityFriendly: maternityFriendly);
      
      // Add sample jobs if no jobs are loaded (for testing)
      if (_jobs.isEmpty) {
        _jobs = _getSampleJobs();
      }
      
      // Filter by maternity friendly if requested
      if (maternityFriendly == true) {
        _jobs = _jobs.where((job) => job.maternityFriendly).toList();
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load jobs: ${e.toString()}');
      // Add sample jobs on error (for testing)
      _jobs = _getSampleJobs();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Create job
  Future<bool> createJob({
    required String title,
    required String company,
    required JobType type,
    required String description,
    required bool maternityFriendly,
    required String employerId,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final job = await _jobService.createJob(
        title: title,
        company: company,
        type: type,
        description: description,
        maternityFriendly: maternityFriendly,
        employerId: employerId,
      );
      
      if (job != null) {
        _jobs.insert(0, job);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to create job');
        return false;
      }
    } catch (e) {
      _setError('Failed to create job: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update job
  Future<bool> updateJob(String jobId, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedJob = await _jobService.updateJob(jobId, data);
      
      if (updatedJob != null) {
        final index = _jobs.indexWhere((job) => job.id == jobId);
        if (index != -1) {
          _jobs[index] = updatedJob;
          notifyListeners();
        }
        return true;
      } else {
        _setError('Failed to update job');
        return false;
      }
    } catch (e) {
      _setError('Failed to update job: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete job
  Future<bool> deleteJob(String jobId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _jobService.deleteJob(jobId);
      
      if (success) {
        _jobs.removeWhere((job) => job.id == jobId);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete job');
        return false;
      }
    } catch (e) {
      _setError('Failed to delete job: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search jobs
  Future<void> searchJobs(String query) async {
    _setLoading(true);
    _clearError();
    
    try {
      _jobs = await _jobService.searchJobs(query);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search jobs: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Toggle maternity friendly filter
  void toggleMaternityFriendlyFilter() {
    _maternityFriendlyFilter = !_maternityFriendlyFilter;
    loadJobs(maternityFriendly: _maternityFriendlyFilter ? true : null);
  }

  // Save job
  void saveJob(JobModel job) {
    if (!_savedJobs.any((savedJob) => savedJob.id == job.id)) {
      _savedJobs.add(job.copyWith(isSaved: true));
      notifyListeners();
    }
  }

  // Remove saved job
  void removeSavedJob(String jobId) {
    _savedJobs.removeWhere((job) => job.id == jobId);
    notifyListeners();
  }

  // Check if job is saved
  bool isJobSaved(String jobId) {
    return _savedJobs.any((job) => job.id == jobId);
  }

  // Get job by ID
  JobModel? getJobById(String jobId) {
    try {
      return _jobs.firstWhere((job) => job.id == jobId);
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

  // Sample jobs for testing
  List<JobModel> _getSampleJobs() {
    return [
      JobModel(
        id: '1',
        title: 'Senior Software Engineer',
        company: 'Google',
        type: JobType.fullTime,
        description: 'We are looking for a Senior Software Engineer to join our team and help build innovative products that impact millions of users worldwide. You will work on cutting-edge technologies and collaborate with talented engineers.',
        maternityFriendly: true,
        employerId: 'employer1',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      JobModel(
        id: '2',
        title: 'Product Manager',
        company: 'Microsoft',
        type: JobType.fullTime,
        description: 'Join our product team to drive the development of next-generation software solutions. You will be responsible for product strategy, roadmap planning, and cross-functional collaboration.',
        maternityFriendly: true,
        employerId: 'employer2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      JobModel(
        id: '3',
        title: 'UX Designer',
        company: 'Apple',
        type: JobType.fullTime,
        description: 'Create beautiful and intuitive user experiences for our products. You will work closely with designers, engineers, and product managers to deliver exceptional user interfaces.',
        maternityFriendly: true,
        employerId: 'employer3',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      JobModel(
        id: '4',
        title: 'Data Scientist',
        company: 'Amazon',
        type: JobType.fullTime,
        description: 'Analyze large datasets to extract insights and build machine learning models. You will work on challenging problems and help drive data-driven decision making.',
        maternityFriendly: false,
        employerId: 'employer4',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      JobModel(
        id: '5',
        title: 'Frontend Developer',
        company: 'Meta',
        type: JobType.remote,
        description: 'Build responsive and interactive web applications using modern JavaScript frameworks. You will work on products that connect billions of people around the world.',
        maternityFriendly: true,
        employerId: 'employer5',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      JobModel(
        id: '6',
        title: 'DevOps Engineer',
        company: 'Netflix',
        type: JobType.fullTime,
        description: 'Design and maintain scalable infrastructure for our streaming platform. You will work on automation, monitoring, and ensuring high availability of our services.',
        maternityFriendly: true,
        employerId: 'employer6',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}

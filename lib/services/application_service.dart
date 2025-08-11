import '../models/application_model.dart';
import '../utils/supabase_config.dart';

class ApplicationService {
  final _supabase = SupabaseConfig.client;

  // Submit job application
  Future<ApplicationModel?> submitApplication({
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
    try {
      // Create the data map with only the required fields first
      final data = {
        'applicant_id': applicantId,
        'name': name,
        'email': email,
        'message': message,
        'resume_url': resumeUrl,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Add job_id only if it's a valid UUID, otherwise skip it
      if (jobId != null && jobId.isNotEmpty && jobId != 'null') {
        data['job_id'] = jobId;
      }

      // Add optional fields only if they are provided
      if (jobTitle != null) data['job_title'] = jobTitle;
      if (companyName != null) data['company_name'] = companyName;
      if (location != null) data['location'] = location;
      if (salary != null) data['salary'] = salary;
      
      // Status is always set to 'Applied' for new applications
      data['status'] = 'Applied';

      final response = await _supabase.from('applications').insert(data).select().single();

      return ApplicationModel.fromJson(response);
    } catch (e) {
      print('Error submitting application: $e');
      return null;
    }
  }

  // Get applications for a job
  Future<List<ApplicationModel>> getApplicationsForJob(String jobId) async {
    try {
      final response = await _supabase
          .from('applications')
          .select()
          .eq('job_id', jobId)
          .order('created_at', ascending: false);

      return response.map((app) => ApplicationModel.fromJson(app)).toList();
    } catch (e) {
      print('Error getting applications for job: $e');
      return [];
    }
  }

  // Get applications by applicant
  Future<List<ApplicationModel>> getApplicationsByApplicant(String applicantId) async {
    try {
      final response = await _supabase
          .from('applications')
          .select()
          .eq('applicant_id', applicantId)
          .order('created_at', ascending: false);

      return response.map((app) => ApplicationModel.fromJson(app)).toList();
    } catch (e) {
      print('Error getting applications by applicant: $e');
      return [];
    }
  }

  // Get application by ID
  Future<ApplicationModel?> getApplicationById(String applicationId) async {
    try {
      final response = await _supabase
          .from('applications')
          .select()
          .eq('id', applicationId)
          .single();

      return ApplicationModel.fromJson(response);
    } catch (e) {
      print('Error getting application by ID: $e');
      return null;
    }
  }

  // Delete application
  Future<bool> deleteApplication(String applicationId) async {
    try {
      await _supabase.from('applications').delete().eq('id', applicationId);
      return true;
    } catch (e) {
      print('Error deleting application: $e');
      return false;
    }
  }
}

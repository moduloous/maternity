import '../models/application_model.dart';
import '../utils/supabase_config.dart';

class ApplicationService {
  final _supabase = SupabaseConfig.client;

  // Submit job application
  Future<ApplicationModel?> submitApplication({
    required String jobId,
    required String applicantId,
    required String name,
    required String email,
    required String message,
    String? resumeUrl,
  }) async {
    try {
      final response = await _supabase.from('applications').insert({
        'job_id': jobId,
        'applicant_id': applicantId,
        'name': name,
        'email': email,
        'message': message,
        'resume_url': resumeUrl,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return ApplicationModel.fromJson(response);
    } catch (e) {
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
      return null;
    }
  }

  // Delete application
  Future<bool> deleteApplication(String applicationId) async {
    try {
      await _supabase.from('applications').delete().eq('id', applicationId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

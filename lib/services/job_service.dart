import '../models/job_model.dart';
import '../utils/supabase_config.dart';

class JobService {
  final _supabase = SupabaseConfig.client;

  // Get all jobs
  Future<List<JobModel>> getJobs({bool? maternityFriendly}) async {
    try {
      var query = _supabase
          .from('jobs')
          .select();

      if (maternityFriendly != null) {
        query = query.eq('maternity_friendly', maternityFriendly);
      }

      final response = await query.order('created_at', ascending: false);
      return response.map((job) => JobModel.fromJson(job)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get job by ID
  Future<JobModel?> getJobById(String jobId) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('id', jobId)
          .single();
      
      return JobModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create new job
  Future<JobModel?> createJob({
    required String title,
    required String company,
    required JobType type,
    required String description,
    required bool maternityFriendly,
    required String employerId,
  }) async {
    try {
      final response = await _supabase.from('jobs').insert({
        'title': title,
        'company': company,
        'type': type.toString().split('.').last,
        'description': description,
        'maternity_friendly': maternityFriendly,
        'employer_id': employerId,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return JobModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Update job
  Future<JobModel?> updateJob(String jobId, Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from('jobs')
          .update(data)
          .eq('id', jobId)
          .select()
          .single();

      return JobModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Delete job
  Future<bool> deleteJob(String jobId) async {
    try {
      await _supabase.from('jobs').delete().eq('id', jobId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get jobs by employer
  Future<List<JobModel>> getJobsByEmployer(String employerId) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('employer_id', employerId)
          .order('created_at', ascending: false);

      return response.map((job) => JobModel.fromJson(job)).toList();
    } catch (e) {
      return [];
    }
  }

  // Search jobs
  Future<List<JobModel>> searchJobs(String query) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .or('title.ilike.%$query%,company.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return response.map((job) => JobModel.fromJson(job)).toList();
    } catch (e) {
      return [];
    }
  }
}

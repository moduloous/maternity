import 'dart:io';
import 'dart:typed_data';
import '../utils/supabase_config.dart';

class StorageService {
  final _supabase = SupabaseConfig.client;

  // Upload resume file
  Future<String?> uploadResume(File file, String userId) async {
    try {
      final fileName = 'resume_${userId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = 'resumes/$fileName';
      
      await _supabase.storage
          .from('documents')
          .upload(filePath, file);

      final url = _supabase.storage
          .from('documents')
          .getPublicUrl(filePath);

      return url;
    } catch (e) {
      return null;
    }
  }

  // Upload resume from bytes
  Future<String?> uploadResumeFromBytes(Uint8List bytes, String userId) async {
    try {
      final fileName = 'resume_${userId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = 'resumes/$fileName';
      
      await _supabase.storage
          .from('documents')
          .uploadBinary(filePath, bytes);

      final url = _supabase.storage
          .from('documents')
          .getPublicUrl(filePath);

      return url;
    } catch (e) {
      return null;
    }
  }

  // Delete file
  Future<bool> deleteFile(String filePath) async {
    try {
      await _supabase.storage
          .from('documents')
          .remove([filePath]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get file URL
  String getFileUrl(String filePath) {
    return _supabase.storage
        .from('documents')
        .getPublicUrl(filePath);
  }
}

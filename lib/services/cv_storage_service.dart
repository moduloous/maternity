import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CVStorageService {
  static const String _cvKey = 'user_cv_data';
  static const String _cvFileNameKey = 'user_cv_filename';
  static const String _cvUploadDateKey = 'user_cv_upload_date';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Store CV/Resume data
  Future<bool> storeCV({
    required String filePath,
    required String fileName,
    required String fileData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Store file data in secure storage
      await _secureStorage.write(key: _cvKey, value: fileData);
      
      // Store metadata in shared preferences
      await prefs.setString(_cvFileNameKey, fileName);
      await prefs.setString(_cvUploadDateKey, DateTime.now().toIso8601String());
      
      return true;
    } catch (e) {
      print('Error storing CV: $e');
      return false;
    }
  }

  // Get CV/Resume data
  Future<Map<String, dynamic>?> getCV() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get file data from secure storage
      final fileData = await _secureStorage.read(key: _cvKey);
      final fileName = prefs.getString(_cvFileNameKey);
      final uploadDate = prefs.getString(_cvUploadDateKey);
      
      if (fileData != null && fileName != null && uploadDate != null) {
        return {
          'fileData': fileData,
          'fileName': fileName,
          'uploadDate': uploadDate,
        };
      }
      
      return null;
    } catch (e) {
      print('Error getting CV: $e');
      return null;
    }
  }

  // Check if CV exists
  Future<bool> hasCV() async {
    try {
      final cvData = await getCV();
      return cvData != null;
    } catch (e) {
      return false;
    }
  }

  // Delete CV/Resume
  Future<bool> deleteCV() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Delete from secure storage
      await _secureStorage.delete(key: _cvKey);
      
      // Delete metadata
      await prefs.remove(_cvFileNameKey);
      await prefs.remove(_cvUploadDateKey);
      
      return true;
    } catch (e) {
      print('Error deleting CV: $e');
      return false;
    }
  }

  // Get CV file info (name and upload date)
  Future<Map<String, String>?> getCVInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final fileName = prefs.getString(_cvFileNameKey);
      final uploadDate = prefs.getString(_cvUploadDateKey);
      
      if (fileName != null && uploadDate != null) {
        return {
          'fileName': fileName,
          'uploadDate': uploadDate,
        };
      }
      
      return null;
    } catch (e) {
      print('Error getting CV info: $e');
      return null;
    }
  }
}

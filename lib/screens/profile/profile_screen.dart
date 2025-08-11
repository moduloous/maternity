import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../services/cv_storage_service.dart';
import 'edit_profile_screen.dart';
import '../applications/my_applications_screen.dart';
import 'cv_display_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CVStorageService _cvStorageService = CVStorageService();
  bool _hasCV = false;
  bool _isLoadingCV = true;

  @override
  void initState() {
    super.initState();
    _checkCVStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh CV status when returning to this screen
    _checkCVStatus();
  }

  Future<void> _checkCVStatus() async {
    setState(() {
      _isLoadingCV = true;
    });
    
    try {
      final hasCV = await _cvStorageService.hasCV();
      setState(() {
        _hasCV = hasCV;
        _isLoadingCV = false;
      });
    } catch (e) {
      setState(() {
        _hasCV = false;
        _isLoadingCV = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFF8E1),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/home');
                }
              },
            ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Show menu options
                  _showMenuOptions(context, authProvider);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Card
                _buildProfileCard(user),
                const SizedBox(height: 24),
                
                // Action Items
                _buildActionItem(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionItem(
                  context,
                  icon: Icons.description,
                  title: 'My Applications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyApplicationsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildCVSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.textPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // User Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          
          // Email
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Role Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pink[200]!),
            ),
            child: Text(
              user.role == UserRole.jobSeeker ? 'Job Seeker' : 'Employer',
              style: TextStyle(
                color: Colors.pink[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.textPrimaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCVSection(BuildContext context) {
    if (_isLoadingCV) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CV/Resume',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        if (_hasCV)
          _buildCVStatus(context)
        else
          _buildUploadCVButton(context),
      ],
    );
  }

  Widget _buildCVStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                'CV Uploaded',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionItem(
            context,
            icon: Icons.visibility,
            title: 'View CV',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CVDisplayScreen(),
                ),
              );
              // Refresh CV status when returning
              _checkCVStatus();
            },
          ),
          const SizedBox(height: 12),
          _buildActionItem(
            context,
            icon: Icons.delete,
            title: 'Delete CV',
            onTap: () {
              _deleteCV(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCVButton(BuildContext context) {
    return _buildActionItem(
      context,
      icon: Icons.upload_file,
      title: 'Add CV/Resume',
      onTap: () {
        _pickCVFromGallery(context);
      },
    );
  }

  void _showMenuOptions(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('My Applications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApplicationsScreen(),
                  ),
                );
              },
            ),
            if (_hasCV)
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View CV/Resume'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CVDisplayScreen(),
                    ),
                  );
                  // Refresh CV status when returning
                  _checkCVStatus();
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Add CV/Resume'),
                onTap: () {
                  Navigator.pop(context);
                  _pickCVFromGallery(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _signOut(context, authProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, AuthProvider authProvider) async {
    await authProvider.signOut();
    if (context.mounted) {
      context.go('/auth/login');
    }
  }

  Future<void> _pickCVFromGallery(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        // Read the file data using readAsBytes() which works on web
        final bytes = await image.readAsBytes();
        final base64Data = base64Encode(bytes);
        
        // Store the CV using CVStorageService
        final success = await _cvStorageService.storeCV(
          filePath: image.path,
          fileName: image.name,
          fileData: base64Data,
        );
        
        if (success) {
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('CV/Resume uploaded successfully: ${image.name}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          
          // Refresh CV status
          await _checkCVStatus();
          
        } else {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to store CV/Resume'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
        
        print('Selected CV/Resume: ${image.name}');
        
      } else {
        // User cancelled the picker
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No CV/Resume selected'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading CV/Resume: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      print('Error picking CV/Resume: $e');
    }
  }

  Future<void> _deleteCV(BuildContext context) async {
    try {
      await _cvStorageService.deleteCV();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CV deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      // Refresh CV status
      await _checkCVStatus();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting CV: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      print('Error deleting CV: $e');
    }
  }
}

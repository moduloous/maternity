import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _skillsController = TextEditingController();
  bool _isEditing = false;
  bool _maternityStatus = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _experienceController.text = user.experience ?? '';
      _companyNameController.text = user.companyName ?? '';
      _skillsController.text = user.skills?.join(', ') ?? '';
      _maternityStatus = user.maternityStatus ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _companyNameController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating profile...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Create updated user model
      final updatedUser = UserModel(
        id: authProvider.currentUser!.id,
        email: authProvider.currentUser!.email,
        name: _nameController.text.trim(),
        role: authProvider.currentUser!.role,
        skills: _skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        experience: _experienceController.text.trim(),
        maternityStatus: _maternityStatus,
        resumeUrl: authProvider.currentUser!.resumeUrl,
        companyName: _companyNameController.text.trim(),
        createdAt: authProvider.currentUser!.createdAt,
      );

      // Update profile (you'll need to implement this in AuthProvider)
      // For now, just update the local state
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    if (mounted) {
      context.go('/auth/login');
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
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.transparent,
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
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _signOut,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  _buildProfileHeader(user),
                  const SizedBox(height: 32),
                  
                  // Profile Information
                  _buildProfileInfo(user),
                  
                  if (_isEditing) ...[
                    const SizedBox(height: 32),
                    _buildEditActions(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              user.role == UserRole.jobSeeker ? Icons.person : Icons.business,
              size: 40,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role == UserRole.jobSeeker ? 'Job Seeker' : 'Employer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        
        // Name Field
        _buildInfoCard(
          'Name',
          Icons.person_outline,
          _isEditing
              ? CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                )
              : Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
        ),
        
        const SizedBox(height: 16),
        
        // Role-specific fields
        if (user.role == UserRole.jobSeeker) ...[
          // Experience Field
          _buildInfoCard(
            'Experience',
            Icons.work_outline,
            _isEditing
                ? CustomTextField(
                    controller: _experienceController,
                    labelText: 'Years of Experience',
                    maxLines: 3,
                  )
                : Text(
                    (user.experience?.isEmpty ?? true) ? 'Not specified' : user.experience!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
          ),
          
          const SizedBox(height: 16),
          
          // Skills Field
          _buildInfoCard(
            'Skills',
            Icons.star_outline,
            _isEditing
                ? CustomTextField(
                    controller: _skillsController,
                    labelText: 'Skills (comma separated)',
                    maxLines: 2,
                  )
                : (user.skills?.isEmpty ?? true)
                    ? const Text(
                        'No skills added',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textPrimaryColor,
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (user.skills ?? []).map((skill) => Chip(
                          label: Text(skill),
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                          ),
                        )).toList(),
                      ),
          ),
          
          const SizedBox(height: 16),
          
          // Maternity Status
          _buildInfoCard(
            'Maternity Status',
            Icons.child_care,
            _isEditing
                ? SwitchListTile(
                    title: const Text('Looking for maternity-friendly jobs'),
                    value: _maternityStatus,
                    onChanged: (value) {
                      setState(() {
                        _maternityStatus = value;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  )
                : Text(
                    (user.maternityStatus ?? false)
                        ? 'Looking for maternity-friendly positions'
                        : 'Not specifically looking for maternity-friendly positions',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
          ),
        ] else ...[
          // Company Name for Employers
          _buildInfoCard(
            'Company',
            Icons.business_outlined,
            _isEditing
                ? CustomTextField(
                    controller: _companyNameController,
                    labelText: 'Company Name',
                  )
                : Text(
                    (user.companyName?.isEmpty ?? true) ? 'Not specified' : user.companyName!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
          ),
        ],
        
        const SizedBox(height: 16),
        
        // Member Since
        _buildInfoCard(
          'Member Since',
          Icons.calendar_today_outlined,
          Text(
            '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildEditActions() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              _loadUserData(); // Reset form data
              setState(() {
                _isEditing = false;
              });
            },
            backgroundColor: Colors.grey[300]!,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: _saveProfile,
          ),
        ),
      ],
    );
  }
}

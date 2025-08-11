import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/application_provider.dart';

class MaternityJobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const MaternityJobDetailScreen({
    super.key,
    required this.jobData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company and Job Info
                    _buildJobInfo(),
                    const SizedBox(height: 24),

                    // Key Benefits
                    _buildKeyBenefits(),
                    const SizedBox(height: 24),

                    // Job Requirements
                    _buildJobRequirements(),
                    const SizedBox(height: 24),

                    // Work Schedule
                    _buildWorkSchedule(),
                    const SizedBox(height: 24),

                    // Application Process
                    _buildApplicationProcess(),
                    const SizedBox(height: 32),

                    // Apply Button
                    _buildApplyButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Time
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          const Spacer(),
          
          // Back arrow
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          
          // Company logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: jobData['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                jobData['logo'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: jobData['color'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company name and logo
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    jobData['logo'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: jobData['color'],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobData['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      jobData['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Job details
          Row(
            children: [
              _buildInfoItem(Icons.location_on, 'Remote'),
              const SizedBox(width: 16),
              _buildInfoItem(Icons.work, 'Full-time'),
              const SizedBox(width: 16),
              _buildInfoItem(Icons.attach_money, jobData['salary'] ?? 'Competitive'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white70,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Benefits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildBenefitItem('Flexible working hours to accommodate your schedule'),
        _buildBenefitItem('Remote work options available'),
        _buildBenefitItem('Comprehensive maternity benefits'),
        _buildBenefitItem('Supportive team environment'),
        _buildBenefitItem('Professional development opportunities'),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: jobData['color'],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Requirements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRequirementItem('• Relevant experience in the field'),
              _buildRequirementItem('• Strong communication skills'),
              _buildRequirementItem('• Ability to work independently'),
              _buildRequirementItem('• Familiarity with remote work tools'),
              _buildRequirementItem('• Passion for the industry'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildWorkSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Work Schedule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildScheduleItem('Monday - Friday', '9:00 AM - 5:00 PM'),
              const Divider(),
              _buildScheduleItem('Flexible Hours', 'Available for adjustments'),
              const Divider(),
              _buildScheduleItem('Remote Work', '100% remote option available'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationProcess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Application Process',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildProcessStep(1, 'Submit Application', 'Send your resume and cover letter'),
        _buildProcessStep(2, 'Initial Screening', 'Phone call to discuss your experience'),
        _buildProcessStep(3, 'Interview', 'Meet with the hiring team'),
        _buildProcessStep(4, 'Offer', 'Receive job offer and discuss terms'),
      ],
    );
  }

  Widget _buildProcessStep(int step, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: jobData['color'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Consumer2<AuthProvider, ApplicationProvider>(
      builder: (context, authProvider, applicationProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: applicationProvider.isLoading
                ? null
                : () => _submitApplication(context, authProvider, applicationProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: jobData['color'],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: applicationProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Apply Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _submitApplication(
    BuildContext context,
    AuthProvider authProvider,
    ApplicationProvider applicationProvider,
  ) async {
    final user = authProvider.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to apply for this job'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      print('Submitting application for job: ${jobData['title']} at ${jobData['name']}');
      print('User ID: ${user.id}, User Name: ${user.name}, User Email: ${user.email}');
      
      // Ensure required fields are not null
      final userName = user.name ?? 'Unknown User';
      final userEmail = user.email ?? 'unknown@email.com';
      final jobTitle = jobData['title'] ?? 'Unknown Position';
      final companyName = jobData['name'] ?? 'Unknown Company';
      final salary = jobData['salary'] ?? 'Not specified';
      
      final success = await applicationProvider.submitApplication(
        // jobId is now optional, so we don't need to pass it
        applicantId: user.id,
        name: userName,
        email: userEmail,
        message: 'I am interested in this $jobTitle position at $companyName. I believe my skills and experience would be a great fit for this role.',
        jobTitle: jobTitle,
        companyName: companyName,
        location: 'Remote', // Default to Remote since most jobs are remote
        salary: salary,
      );

      if (success) {
        if (context.mounted) {
          // Don't refresh here since the provider already adds the new application
          // This prevents duplicate applications from appearing
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          final errorMessage = applicationProvider.error ?? 'Failed to submit application';
          print('Application submission failed: $errorMessage');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit application: $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print('Exception during application submission: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}

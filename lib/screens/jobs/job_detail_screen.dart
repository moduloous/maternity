import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/job_model.dart';
import '../../providers/job_provider.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  JobModel? _job;
  bool _isLoading = true;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  Future<void> _loadJobDetails() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    try {
      final job = await jobProvider.getJobById(widget.jobId);
      setState(() {
        _job = job;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load job details: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _applyForJob() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final applicationProvider = Provider.of<ApplicationProvider>(context, listen: false);
    
    if (authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to apply for jobs'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isApplying = true;
    });

    try {
      final success = await applicationProvider.submitApplication(
        jobId: widget.jobId,
        applicantId: authProvider.currentUser!.id,
        name: authProvider.currentUser!.name,
        email: authProvider.currentUser!.email,
        message: 'I am interested in this position and would like to be considered for the role.',
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back or to applications screen
        context.go('/applications');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(applicationProvider.error ?? 'Failed to submit application'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting application: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      setState(() {
        _isApplying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _job == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Job not found',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The job you are looking for does not exist.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Header
                    _buildHeader(),
                    
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

                            // Key Details
                            _buildKeyDetails(),
                            const SizedBox(height: 24),

                            // Minimum Qualifications
                            _buildMinimumQualifications(),
                            const SizedBox(height: 32),

                            // Apply Button
                            _buildApplyButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildHeader() {
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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go('/home');
              }
            },
          ),
          
          // Company logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getCompanyColor(_job?.company ?? ''),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _job?.company.substring(0, 1).toUpperCase() ?? 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Bookmark icon
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _job?.company ?? 'Amazon',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _job?.title ?? 'Software Development Engineer.',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getLocationText(),
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyDetails() {
    return Row(
      children: [
        _buildDetailChip(
          icon: Icons.attach_money,
          label: '\$150k-\$200K',
          color: AppTheme.textPrimaryColor,
        ),
        const SizedBox(width: 16),
        _buildDetailChip(
          icon: Icons.business,
          label: 'On-Site',
          color: AppTheme.textPrimaryColor,
        ),
        const SizedBox(width: 16),
        _buildDetailChip(
          icon: Icons.work,
          label: '5+',
          color: AppTheme.textPrimaryColor,
        ),
      ],
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimumQualifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum Qualification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildQualificationItem(
          'Bachelor\'s degree or equivalent practical experience.',
        ),
        const SizedBox(height: 12),
        _buildQualificationItem(
          'Completed course offerings listed in DoD 8140 Training repository, or CEH, GSEC or Security+ certification.',
        ),
        const SizedBox(height: 12),
        _buildQualificationItem(
          '5 years of experience in technical project management, stakeholder management, professional services, solution engineering or technical consulting.',
        ),
      ],
    );
  }

  Widget _buildQualificationItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: AppTheme.textPrimaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimaryColor,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isApplying ? null : _applyForJob,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isApplying
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Apply for this job',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Color _getCompanyColor(String company) {
    switch (company.toLowerCase()) {
      case 'uber':
        return AppTheme.uberPurple;
      case 'amazon':
        return AppTheme.amazonOrange;
      case 'microsoft':
        return AppTheme.microsoftBlue;
      case 'google':
        return AppTheme.googleGreen;
      default:
        return AppTheme.amazonOrange; // Default to Amazon orange
    }
  }

  String _getLocationText() {
    // Simulate different locations based on company
    final locations = {
      'Google': 'Mountain View, CA',
      'Microsoft': 'Redmond, WA',
      'Apple': 'Cupertino, CA',
      'Amazon': 'California, USA',
      'Meta': 'Menlo Park, CA',
      'Netflix': 'Los Gatos, CA',
      'Salesforce': 'San Francisco, CA',
      'Adobe': 'San Jose, CA',
      'Intel': 'Santa Clara, CA',
      'Oracle': 'Austin, TX',
    };
    return locations[_job?.company] ?? 'California, USA';
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/theme.dart';

class InterviewStagesScreen extends StatelessWidget {
  final String jobId;
  final String companyName;

  const InterviewStagesScreen({
    super.key,
    required this.jobId,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
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
                    // Title
                    const Text(
                      'Amazon Interview Stages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Interview Stages
                    _buildStageCard(
                      title: 'Resume screen',
                      description: 'First, you\'ll need to convince recruiters that you have a strong enough profile to be invited to the first round.',
                      color: AppTheme.resumeScreenColor,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildStageCard(
                      title: 'Recruiter call',
                      description: 'Once your resume has been approved, an Amazon recruiter will schedule a roughly 30 minute call with you.',
                      color: AppTheme.recruiterCallColor,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildStageCard(
                      title: 'Assessments',
                      description: 'There is the one general category of the Amazon interview assessments: work sample simulations.',
                      color: AppTheme.assessmentColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Builder(
      builder: (context) => Container(
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
            
            // Title
            const Text(
              'Interview Stages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            
            const Spacer(),
            
            // Menu icon
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Stage content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Arrow icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

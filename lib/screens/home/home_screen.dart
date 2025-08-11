import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../widgets/modern_job_card.dart';
import '../../widgets/search_bar.dart';
import 'maternity_job_detail_screen.dart';
import 'job_filter_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();
  bool _showingFallbackResults = false;
  Map<String, dynamic> _filters = {
    'minSalary': 5.0,
    'maxSalary': 120.0,
    'skills': <dynamic>[],
    'workHours': <dynamic>[],
    'locations': <dynamic>[],
    'experienceLevels': <dynamic>[],
    'jobTypes': <dynamic>[],
    'companyTypes': <dynamic>[],
    'maternityBenefits': <dynamic>[],
    'remoteWork': 'any',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).loadJobs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildJobFeedScreen(JobProvider jobProvider, UserModel? currentUser) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
      body: SafeArea(
        child: Column(
          children: [
            // Header with time, profile, and search
            _buildHeader(currentUser),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Title and Filters
                    _buildTitleSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Company Cards (exactly like the image)
                    _buildCompanyCards(),
                    
                    const SizedBox(height: 20), // Reduced space since nav bar is floating
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel? currentUser) {
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
          
          // Profile section - exactly like the image
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  currentUser?.name.isNotEmpty == true 
                      ? currentUser!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    currentUser?.email ?? 'user@example.com',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Search icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              size: 20,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      children: [
        // Title in two lines - 40% of the page
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EXPLORE',
                style: TextStyle(
                  fontFamily: 'Bungee', // Use Bungee font for headings
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const Text(
                'VACANCIES',
                style: TextStyle(
                  fontFamily: 'Bungee', // Use Bungee font for headings
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Filters button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: GestureDetector(
            onTap: _openFilterScreen,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.filter_list,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Filters',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyCards() {
    final allCompanies = [
      // Indian Companies
      {
        'name': 'TCS (Tata Consultancy Services)',
        'color': AppTheme.uberPurple,
        'logo': 'T',
        'stage': 'Stage 1',
        'title': 'Software Developer (Maternity-Friendly)',
        'description': 'Develop software solutions with flexible hours and remote work options, perfect for expecting mothers and new parents.',
        'salary': '₹8-12 LPA',
        'skills': ['Software Development', 'Project Management'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Remote', 'Hybrid', 'Bangalore', 'Mumbai'],
        'experienceLevels': ['Entry Level (0-2 years)', 'Mid Level (3-5 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Extended Maternity Leave', 'Flexible Working Hours', 'Remote Work Options'],
        'remoteWork': 'hybrid',
        'salaryRange': 10.0,
      },
      {
        'name': 'Infosys',
        'color': AppTheme.amazonOrange,
        'logo': 'I',
        'stage': 'Stage 2',
        'title': 'Business Analyst (Parent-Friendly)',
        'description': 'Analyze business requirements with work-from-home flexibility and understanding maternity needs.',
        'salary': '₹7-11 LPA',
        'skills': ['Business Analysis', 'Data Analysis'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Hybrid', 'Bangalore', 'Pune'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Extended Maternity Leave', 'Health Insurance', 'Childcare Support'],
        'remoteWork': 'remote',
        'salaryRange': 9.0,
      },
      {
        'name': 'Wipro',
        'color': AppTheme.microsoftBlue,
        'logo': 'W',
        'stage': 'Stage 3',
        'title': 'Project Manager (Maternity Support)',
        'description': 'Manage IT projects with flexible scheduling and comprehensive maternity benefits.',
        'salary': '₹6-10 LPA',
        'skills': ['Project Management', 'Business Analysis'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Bangalore', 'Delhi'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Extended Maternity Leave', 'Mental Health Support'],
        'remoteWork': 'hybrid',
        'salaryRange': 8.0,
      },
      {
        'name': 'HCL Technologies',
        'color': AppTheme.googleGreen,
        'logo': 'H',
        'stage': 'Stage 4',
        'title': 'QA Engineer (Remote-Friendly)',
        'description': 'Quality assurance testing with remote work options and family-friendly policies.',
        'salary': '₹7-12 LPA',
        'skills': ['Quality Assurance', 'Software Development'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Noida', 'Chennai'],
        'experienceLevels': ['Entry Level (0-2 years)', 'Mid Level (3-5 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Remote Work Options', 'Health Insurance'],
        'remoteWork': 'remote',
        'salaryRange': 9.5,
      },
      {
        'name': 'Tech Mahindra',
        'color': Colors.grey[800]!,
        'logo': 'T',
        'stage': 'Stage 5',
        'title': 'Data Analyst (Flexible Hours)',
        'description': 'Analyze data with flexible work hours and understanding of maternity requirements.',
        'salary': '₹8-13 LPA',
        'skills': ['Data Analysis', 'Business Analysis'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Pune', 'Mumbai'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Flexible Working Hours', 'Prenatal Care'],
        'remoteWork': 'hybrid',
        'salaryRange': 10.5,
      },
      {
        'name': 'L&T Infotech',
        'color': Colors.red[600]!,
        'logo': 'L',
        'stage': 'Stage 6',
        'title': 'System Administrator (Parent-Friendly)',
        'description': 'Manage IT systems with remote access and family-supportive work environment.',
        'salary': '₹6-11 LPA',
        'skills': ['System Administration', 'Cybersecurity'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Mumbai', 'Bangalore'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Childcare Support', 'No Pressure Policy'],
        'remoteWork': 'remote',
        'salaryRange': 8.5,
      },
      
      // Foreign Companies - India Branch
      {
        'name': 'Accenture India',
        'color': Colors.indigo[600]!,
        'logo': 'A',
        'stage': 'Stage 7',
        'title': 'Consultant (Maternity-Friendly)',
        'description': 'Business consulting with flexible client meetings and remote work capabilities.',
        'salary': '₹10-15 LPA',
        'skills': ['Business Analysis', 'Project Management'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Bangalore', 'Gurgaon'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Consulting'],
        'maternityBenefits': ['Extended Maternity Leave', 'Mental Health Support'],
        'remoteWork': 'hybrid',
        'salaryRange': 12.5,
      },
      {
        'name': 'IBM India',
        'color': Colors.blue[700]!,
        'logo': 'I',
        'stage': 'Stage 8',
        'title': 'Cloud Engineer (Parent-Friendly)',
        'description': 'Cloud infrastructure management with work-from-home options and maternity support.',
        'salary': '₹9-14 LPA',
        'skills': ['Cloud Computing', 'DevOps'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Bangalore', 'Pune'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Remote Work Options', 'Health Insurance'],
        'remoteWork': 'remote',
        'salaryRange': 11.5,
      },
      {
        'name': 'Cognizant India',
        'color': Colors.teal[600]!,
        'logo': 'C',
        'stage': 'Stage 9',
        'title': 'DevOps Engineer (Flexible Schedule)',
        'description': 'DevOps operations with flexible hours and understanding of maternity needs.',
        'salary': '₹8-13 LPA',
        'skills': ['DevOps', 'Cloud Computing'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Chennai', 'Bangalore'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Service Company'],
        'maternityBenefits': ['Flexible Working Hours', 'Prenatal Care'],
        'remoteWork': 'hybrid',
        'salaryRange': 10.5,
      },
      {
        'name': 'Capgemini India',
        'color': Colors.orange[600]!,
        'logo': 'C',
        'stage': 'Stage 10',
        'title': 'UI/UX Designer (Remote Work)',
        'description': 'Design user interfaces with remote work options and family-friendly policies.',
        'salary': '₹7-12 LPA',
        'skills': ['UI/UX Design', 'Software Development'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Mumbai', 'Pune'],
        'experienceLevels': ['Entry Level (0-2 years)', 'Mid Level (3-5 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Service Company'],
        'maternityBenefits': ['Remote Work Options', 'Childcare Support'],
        'remoteWork': 'remote',
        'salaryRange': 9.5,
      },
      
      // American Companies - Remote Opportunities
      {
        'name': 'Microsoft',
        'color': Colors.blue[600]!,
        'logo': 'M',
        'stage': 'Stage 11',
        'title': 'Product Manager (Maternity-Friendly)',
        'description': 'Manage software products with flexible hours and comprehensive maternity benefits.',
        'salary': '₹60-90 LPA',
        'skills': ['Project Management', 'Business Analysis'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Remote', 'Hybrid', 'Bangalore'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Extended Maternity Leave', 'Health Insurance', 'Mental Health Support'],
        'remoteWork': 'hybrid',
        'salaryRange': 75.0,
      },
      {
        'name': 'Google',
        'color': Colors.green[600]!,
        'logo': 'G',
        'stage': 'Stage 12',
        'title': 'Machine Learning Engineer (Parent-Friendly)',
        'description': 'Develop ML models with remote work options and family-supportive environment.',
        'salary': '₹70-100 LPA',
        'skills': ['Machine Learning', 'Data Analysis'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Bangalore', 'Hyderabad'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Remote Work Options', 'Childcare Support', 'No Pressure Policy'],
        'remoteWork': 'remote',
        'salaryRange': 85.0,
      },
      {
        'name': 'Amazon',
        'color': Colors.orange[600]!,
        'logo': 'A',
        'stage': 'Stage 13',
        'title': 'Solutions Architect (Flexible Hours)',
        'description': 'Design cloud solutions with flexible scheduling and maternity understanding.',
        'salary': '₹65-95 LPA',
        'skills': ['Cloud Computing', 'System Administration'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Bangalore', 'Gurgaon'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Flexible Working Hours', 'Health Insurance'],
        'remoteWork': 'hybrid',
        'salaryRange': 80.0,
      },
      {
        'name': 'Meta',
        'color': Colors.indigo[600]!,
        'logo': 'F',
        'stage': 'Stage 14',
        'title': 'Frontend Developer (Remote Work)',
        'description': 'Develop user interfaces with remote work capabilities and family-friendly policies.',
        'salary': '₹75-110 LPA',
        'skills': ['Software Development', 'UI/UX Design'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Bangalore'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Remote Work Options', 'Mental Health Support'],
        'remoteWork': 'remote',
        'salaryRange': 92.5,
      },
      {
        'name': 'Apple',
        'color': Colors.grey[700]!,
        'logo': 'A',
        'stage': 'Stage 15',
        'title': 'iOS Developer (Maternity Support)',
        'description': 'Develop iOS applications with flexible hours and comprehensive maternity benefits.',
        'salary': '₹68-102 LPA',
        'skills': ['Software Development', 'UI/UX Design'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Bangalore', 'Hyderabad'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Extended Maternity Leave', 'Prenatal Care'],
        'remoteWork': 'hybrid',
        'salaryRange': 85.0,
      },
      {
        'name': 'Netflix',
        'color': Colors.red[600]!,
        'logo': 'N',
        'stage': 'Stage 16',
        'title': 'Content Strategist (Parent-Friendly)',
        'description': 'Develop content strategies with remote work options and family-supportive environment.',
        'salary': '₹80-120 LPA',
        'skills': ['Business Analysis', 'Data Analysis'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Mumbai'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Remote Work Options', 'Childcare Support', 'No Pressure Policy'],
        'remoteWork': 'remote',
        'salaryRange': 100.0,
      },
      
      // Additional Indian Tech Companies
      {
        'name': 'Mindtree',
        'color': Colors.purple[600]!,
        'logo': 'T',
        'stage': 'Stage 17',
        'title': 'Full Stack Developer (Flexible Hours)',
        'description': 'Full-stack development with flexible scheduling and maternity understanding.',
        'salary': '₹6-10 LPA',
        'skills': ['Software Development', 'Database Management'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Bangalore', 'Pune'],
        'experienceLevels': ['Entry Level (0-2 years)', 'Mid Level (3-5 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Flexible Working Hours', 'Health Insurance'],
        'remoteWork': 'hybrid',
        'salaryRange': 8.0,
      },
      {
        'name': 'Mphasis',
        'color': Colors.cyan[600]!,
        'logo': 'P',
        'stage': 'Stage 18',
        'title': 'Database Administrator (Remote Work)',
        'description': 'Database management with remote access and family-friendly policies.',
        'salary': '₹7-11 LPA',
        'skills': ['Database Management', 'System Administration'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Bangalore', 'Chennai'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Remote Work Options', 'Childcare Support'],
        'remoteWork': 'remote',
        'salaryRange': 9.0,
      },
      {
        'name': 'Persistent Systems',
        'color': Colors.lime[600]!,
        'logo': 'P',
        'stage': 'Stage 19',
        'title': 'Security Analyst (Parent-Friendly)',
        'description': 'Cybersecurity analysis with flexible hours and maternity support.',
        'salary': '₹8-12 LPA',
        'skills': ['Cybersecurity', 'System Administration'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Pune', 'Mumbai'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Indian MNC', 'Service Company'],
        'maternityBenefits': ['Health Insurance', 'Mental Health Support'],
        'remoteWork': 'hybrid',
        'salaryRange': 10.0,
      },
      
      // Additional American Companies
      {
        'name': 'Salesforce',
        'color': Colors.blue[500]!,
        'logo': 'S',
        'stage': 'Stage 20',
        'title': 'Salesforce Developer (Maternity-Friendly)',
        'description': 'Develop Salesforce solutions with remote work options and family-supportive environment.',
        'salary': '₹65-98 LPA',
        'skills': ['Software Development', 'Database Management'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Bangalore', 'Hyderabad'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Remote Work Options', 'Health Insurance'],
        'remoteWork': 'remote',
        'salaryRange': 81.5,
      },
      {
        'name': 'Adobe',
        'color': Colors.orange[500]!,
        'logo': 'A',
        'stage': 'Stage 21',
        'title': 'Creative Designer (Flexible Schedule)',
        'description': 'Creative design work with flexible hours and understanding of maternity needs.',
        'salary': '₹70-102 LPA',
        'skills': ['UI/UX Design', 'Software Development'],
        'workHours': ['Full Time', 'Flexible Hours'],
        'locations': ['Hybrid', 'Bangalore', 'Noida'],
        'experienceLevels': ['Mid Level (3-5 years)', 'Senior Level (6-8 years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Flexible Working Hours', 'Mental Health Support'],
        'remoteWork': 'hybrid',
        'salaryRange': 86.0,
      },
      {
        'name': 'Oracle',
        'color': Colors.red[500]!,
        'logo': 'O',
        'stage': 'Stage 22',
        'title': 'Database Engineer (Parent-Friendly)',
        'description': 'Database engineering with remote work capabilities and family-friendly policies.',
        'salary': '₹60-95 LPA',
        'skills': ['Database Management', 'System Administration'],
        'workHours': ['Full Time', 'Remote Only'],
        'locations': ['Remote', 'Bangalore', 'Pune'],
        'experienceLevels': ['Senior Level (6-8 years)', 'Lead Level (9+ years)'],
        'jobTypes': ['Permanent'],
        'companyTypes': ['Foreign MNC', 'Product Company'],
        'maternityBenefits': ['Remote Work Options', 'Childcare Support'],
        'remoteWork': 'remote',
        'salaryRange': 77.5,
      },
    ];

    // Apply filters
    final filteredCompanies = _applyFilters(allCompanies);

    return Column(
      children: [
        // Show fallback indicator if needed
        if (_showingFallbackResults)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Showing similar jobs that match some of your criteria',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Company cards
        ...filteredCompanies.map((company) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaternityJobDetailScreen(jobData: company),
                  ),
                );
              },
              child: _buildCompanyCard(company),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: company['color'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with arrow button only
          Row(
            children: [
              const Spacer(),
              
              // Circular arrow button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_upward,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Company name and logo
          Row(
            children: [
              // Company logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    company['logo'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: company['color'],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Company name
              Text(
                company['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            company['title'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Description
          Text(
            company['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          
          // Salary if available
          if (company['salary'] != null) ...[
            const SizedBox(height: 12),
            Text(
              company['salary'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.work_outline,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: const Center(
        child: Text('Location Screen - Coming Soon'),
      ),
    );
  }

  Widget _buildChatScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // HR Contact Information Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.people,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HR Contact Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            Text(
                              'Important Update',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Main message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Selection Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'If you are selected to proceed to the next round, our HR team will contact you directly.',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.textPrimaryColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Additional information
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'You will receive a call or email from HR',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Response time: Within 2-3 business days',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Chat coming soon message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 48,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chat Feature Coming Soon',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Direct messaging with HR and recruiters will be available soon.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications Screen - Coming Soon'),
      ),
    );
  }

  Widget _buildSavedJobsScreen(JobProvider jobProvider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
      ),
      body: jobProvider.savedJobs.isEmpty
          ? _buildEmptySavedJobs()
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: jobProvider.savedJobs.length,
              itemBuilder: (context, index) {
                final job = jobProvider.savedJobs[index];
                return ModernJobCard(
                  job: job,
                  onTap: () => context.go('/job/${job.id}'),
                );
              },
            ),
    );
  }

  Widget _buildEmptySavedJobs() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved jobs',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Save jobs you\'re interested in to view them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildJobFeedScreen(jobProvider, currentUser),
                _buildChatScreen(),
                const ProfileScreen(),
              ],
            ),
            // Floating navigation bar positioned at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildFloatingNavigationBar(),
            ),
          ],
        ),
      ),
      floatingActionButton: currentUser?.role == UserRole.employer
          ? FloatingActionButton(
              onPressed: () => context.go('/post-job'),
              child: const Icon(
                Icons.add,
                size: 24,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.chat_bubble, 'Chat'),
            _buildNavItem(2, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobFilterScreen(
          currentFilters: _filters,
          onFiltersApplied: (filters) {
            setState(() {
              _filters = filters;
            });
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> companies) {
    // First, try to apply all filters strictly
    var filteredCompanies = companies.where((company) {
      // Salary filter
      final salaryRange = company['salaryRange'] as double? ?? 0.0;
      if (salaryRange < _filters['minSalary'] || salaryRange > _filters['maxSalary']) {
        return false;
      }

      // Skills filter
      if (_filters['skills'] != null && _filters['skills'].isNotEmpty) {
        final companySkills = company['skills'] as List<dynamic>? ?? [];
        final hasMatchingSkill = _filters['skills'].any((skill) => companySkills.contains(skill));
        if (!hasMatchingSkill) return false;
      }

      // Work hours filter
      if (_filters['workHours'] != null && _filters['workHours'].isNotEmpty) {
        final companyWorkHours = company['workHours'] as List<dynamic>? ?? [];
        final hasMatchingWorkHours = _filters['workHours'].any((hours) => companyWorkHours.contains(hours));
        if (!hasMatchingWorkHours) return false;
      }

      // Location filter
      if (_filters['locations'] != null && _filters['locations'].isNotEmpty) {
        final companyLocations = company['locations'] as List<dynamic>? ?? [];
        final hasMatchingLocation = _filters['locations'].any((location) => companyLocations.contains(location));
        if (!hasMatchingLocation) return false;
      }

      // Experience level filter
      if (_filters['experienceLevels'] != null && _filters['experienceLevels'].isNotEmpty) {
        final companyExperienceLevels = company['experienceLevels'] as List<dynamic>? ?? [];
        final hasMatchingExperience = _filters['experienceLevels'].any((level) => companyExperienceLevels.contains(level));
        if (!hasMatchingExperience) return false;
      }

      // Job type filter
      if (_filters['jobTypes'] != null && _filters['jobTypes'].isNotEmpty) {
        final companyJobTypes = company['jobTypes'] as List<dynamic>? ?? [];
        final hasMatchingJobType = _filters['jobTypes'].any((type) => companyJobTypes.contains(type));
        if (!hasMatchingJobType) return false;
      }

      // Company type filter
      if (_filters['companyTypes'] != null && _filters['companyTypes'].isNotEmpty) {
        final companyTypes = company['companyTypes'] as List<dynamic>? ?? [];
        final hasMatchingCompanyType = _filters['companyTypes'].any((type) => companyTypes.contains(type));
        if (!hasMatchingCompanyType) return false;
      }

      // Maternity benefits filter
      if (_filters['maternityBenefits'] != null && _filters['maternityBenefits'].isNotEmpty) {
        final companyBenefits = company['maternityBenefits'] as List<dynamic>? ?? [];
        final hasMatchingBenefits = _filters['maternityBenefits'].any((benefit) => companyBenefits.contains(benefit));
        if (!hasMatchingBenefits) return false;
      }

      // Remote work filter
      if (_filters['remoteWork'] != null && _filters['remoteWork'] != 'any') {
        final companyRemoteWork = company['remoteWork'] as String? ?? '';
        if (_filters['remoteWork'] != companyRemoteWork) return false;
      }

      return true;
    }).toList();

    // If we have at least 2 results, return them
    if (filteredCompanies.length >= 2) {
      setState(() {
        _showingFallbackResults = false;
      });
      return filteredCompanies;
    }

    // If we have 1 result, return it
    if (filteredCompanies.length == 1) {
      setState(() {
        _showingFallbackResults = false;
      });
      return filteredCompanies;
    }

    // If no results, apply fallback logic - try with fewer filters
    setState(() {
      _showingFallbackResults = true;
    });
    return _applyFallbackFilters(companies);
  }

  List<Map<String, dynamic>> _applyFallbackFilters(List<Map<String, dynamic>> companies) {
    // Try with only the most important filters
    var fallbackCompanies = companies.where((company) {
      // Always apply salary filter as it's most important
      final salaryRange = company['salaryRange'] as double? ?? 0.0;
      if (salaryRange < _filters['minSalary'] || salaryRange > _filters['maxSalary']) {
        return false;
      }

      // Apply remote work filter if specified
      if (_filters['remoteWork'] != null && _filters['remoteWork'] != 'any') {
        final companyRemoteWork = company['remoteWork'] as String? ?? '';
        if (_filters['remoteWork'] != companyRemoteWork) return false;
      }

      // Apply at least one other filter if available
      bool hasOtherFilter = false;
      
      // Try skills filter
      if (_filters['skills'] != null && _filters['skills'].isNotEmpty) {
        final companySkills = company['skills'] as List<dynamic>? ?? [];
        final hasMatchingSkill = _filters['skills'].any((skill) => companySkills.contains(skill));
        if (hasMatchingSkill) hasOtherFilter = true;
      }

      // Try work hours filter
      if (!hasOtherFilter && _filters['workHours'] != null && _filters['workHours'].isNotEmpty) {
        final companyWorkHours = company['workHours'] as List<dynamic>? ?? [];
        final hasMatchingWorkHours = _filters['workHours'].any((hours) => companyWorkHours.contains(hours));
        if (hasMatchingWorkHours) hasOtherFilter = true;
      }

      // Try location filter
      if (!hasOtherFilter && _filters['locations'] != null && _filters['locations'].isNotEmpty) {
        final companyLocations = company['locations'] as List<dynamic>? ?? [];
        final hasMatchingLocation = _filters['locations'].any((location) => companyLocations.contains(location));
        if (hasMatchingLocation) hasOtherFilter = true;
      }

      // Try maternity benefits filter
      if (!hasOtherFilter && _filters['maternityBenefits'] != null && _filters['maternityBenefits'].isNotEmpty) {
        final companyBenefits = company['maternityBenefits'] as List<dynamic>? ?? [];
        final hasMatchingBenefits = _filters['maternityBenefits'].any((benefit) => companyBenefits.contains(benefit));
        if (hasMatchingBenefits) hasOtherFilter = true;
      }

      // If no other filters are applied, accept the job
      if (_filters['skills']?.isEmpty == true && 
          _filters['workHours']?.isEmpty == true && 
          _filters['locations']?.isEmpty == true && 
          _filters['experienceLevels']?.isEmpty == true && 
          _filters['jobTypes']?.isEmpty == true && 
          _filters['companyTypes']?.isEmpty == true && 
          _filters['maternityBenefits']?.isEmpty == true) {
        hasOtherFilter = true;
      }

      return hasOtherFilter;
    }).toList();

    // If we still have no results, return top 2 companies by salary
    if (fallbackCompanies.isEmpty) {
      fallbackCompanies = companies.take(2).toList();
    }

    // If we have only 1 result, add one more company
    if (fallbackCompanies.length == 1) {
      final remainingCompanies = companies.where((company) => 
        !fallbackCompanies.contains(company)
      ).toList();
      
      if (remainingCompanies.isNotEmpty) {
        fallbackCompanies.add(remainingCompanies.first);
      }
    }

    // Ensure we return at least 2 companies, but no more than 5
    if (fallbackCompanies.length > 5) {
      fallbackCompanies = fallbackCompanies.take(5).toList();
    }

    return fallbackCompanies;
  }
  
}

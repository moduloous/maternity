import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../widgets/job_card.dart';
import '../../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildJobFeedScreen(jobProvider, currentUser),
          _buildSavedJobsScreen(jobProvider),
          _buildProfileScreen(authProvider, currentUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: currentUser?.role == UserRole.employer
          ? FloatingActionButton(
              onPressed: () => context.go('/post-job'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildJobFeedScreen(JobProvider jobProvider, UserModel? currentUser) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maternity Jobs'),
        actions: [
          if (currentUser?.role == UserRole.jobSeeker)
            IconButton(
              icon: Icon(
                jobProvider.maternityFriendlyFilter
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
                color: jobProvider.maternityFriendlyFilter
                    ? AppTheme.primaryColor
                    : null,
              ),
              onPressed: () {
                jobProvider.toggleMaternityFriendlyFilter();
              },
              tooltip: 'Maternity Friendly Only',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              controller: _searchController,
              onSearch: (query) {
                if (query.isNotEmpty) {
                  jobProvider.searchJobs(query);
                } else {
                  jobProvider.loadJobs();
                }
              },
            ),
          ),
          
          // Filter Chip
          if (jobProvider.maternityFriendlyFilter)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Chip(
                    label: const Text('Maternity Friendly Only'),
                    onDeleted: () {
                      jobProvider.toggleMaternityFriendlyFilter();
                    },
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                ],
              ),
            ),
          
          // Job List
          Expanded(
            child: jobProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : jobProvider.jobs.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => jobProvider.loadJobs(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: jobProvider.jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobProvider.jobs[index];
                            return JobCard(
                              job: job,
                              isSaved: jobProvider.isJobSaved(job.id),
                              onTap: () => context.go('/job/${job.id}'),
                              onSave: () {
                                if (jobProvider.isJobSaved(job.id)) {
                                  jobProvider.removeSavedJob(job.id);
                                } else {
                                  jobProvider.saveJob(job);
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
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
                return JobCard(
                  job: job,
                  isSaved: true,
                  onTap: () => context.go('/job/${job.id}'),
                  onSave: () => jobProvider.removeSavedJob(job.id),
                );
              },
            ),
    );
  }

  Widget _buildProfileScreen(AuthProvider authProvider, UserModel? currentUser) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) {
                context.go('/auth/login');
              }
            },
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              currentUser.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentUser.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentUser.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(
                              currentUser.role == UserRole.jobSeeker
                                  ? 'Job Seeker'
                                  : 'Employer',
                            ),
                            backgroundColor: AppTheme.secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Profile Actions
                  if (currentUser.role == UserRole.jobSeeker) ...[
                    _buildProfileAction(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () => context.go('/profile'),
                    ),
                    _buildProfileAction(
                      icon: Icons.description,
                      title: 'My Applications',
                      onTap: () => context.go('/applications'),
                    ),
                  ] else ...[
                    _buildProfileAction(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () => context.go('/profile'),
                    ),
                    _buildProfileAction(
                      icon: Icons.work,
                      title: 'My Job Postings',
                      onTap: () => context.go('/applications'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProfileAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 64,
            color: AppTheme.textSecondaryColor,
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

  Widget _buildEmptySavedJobs() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 64,
            color: AppTheme.textSecondaryColor,
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
}

import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class JobFilterScreen extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const JobFilterScreen({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<JobFilterScreen> createState() => _JobFilterScreenState();
}

class _JobFilterScreenState extends State<JobFilterScreen> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter Jobs',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Helpful message about fallback system
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Don\'t worry! We\'ll always show you relevant jobs, even if they don\'t match all your criteria.',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Salary Range
                  _buildSalaryFilter(),
                  const SizedBox(height: 24),

                  // Skills
                  _buildSkillsFilter(),
                  const SizedBox(height: 24),

                  // Work Hours
                  _buildWorkHoursFilter(),
                  const SizedBox(height: 24),

                  // Location
                  _buildLocationFilter(),
                  const SizedBox(height: 24),

                  // Experience Level
                  _buildExperienceFilter(),
                  const SizedBox(height: 24),

                  // Job Type
                  _buildJobTypeFilter(),
                  const SizedBox(height: 24),

                  // Company Type
                  _buildCompanyTypeFilter(),
                  const SizedBox(height: 24),

                  // Maternity Benefits
                  _buildMaternityBenefitsFilter(),
                  const SizedBox(height: 24),

                  // Remote Work
                  _buildRemoteWorkFilter(),
                ],
              ),
            ),
          ),
          
          // Apply Filters Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Salary Range (LPA)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        RangeSlider(
          values: RangeValues(
            _filters['minSalary']?.toDouble() ?? 5.0,
            _filters['maxSalary']?.toDouble() ?? 120.0,
          ),
          min: 5.0,
          max: 120.0,
          divisions: 23,
          labels: RangeLabels(
            '₹${_filters['minSalary']?.toInt() ?? 5} LPA',
            '₹${_filters['maxSalary']?.toInt() ?? 120} LPA',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _filters['minSalary'] = values.start;
              _filters['maxSalary'] = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${_filters['minSalary']?.toInt() ?? 5} LPA',
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '₹${_filters['maxSalary']?.toInt() ?? 120} LPA',
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsFilter() {
    final skills = [
      'Software Development',
      'Data Analysis',
      'Project Management',
      'UI/UX Design',
      'DevOps',
      'Cloud Computing',
      'Machine Learning',
      'Database Management',
      'Cybersecurity',
      'Business Analysis',
      'Quality Assurance',
      'System Administration',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            final isSelected = (_filters['skills'] as List<dynamic>?)?.contains(skill) ?? false;
            return FilterChip(
              label: Text(skill),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['skills'] == null) {
                    _filters['skills'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['skills'].add(skill);
                  } else {
                    _filters['skills'].remove(skill);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWorkHoursFilter() {
    final workHours = [
      'Full Time',
      'Part Time',
      'Flexible Hours',
      'Remote Only',
      'Hybrid',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Work Hours',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: workHours.map((hours) {
            final isSelected = (_filters['workHours'] as List<dynamic>?)?.contains(hours) ?? false;
            return FilterChip(
              label: Text(hours),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['workHours'] == null) {
                    _filters['workHours'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['workHours'].add(hours);
                  } else {
                    _filters['workHours'].remove(hours);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationFilter() {
    final locations = [
      'Remote',
      'Hybrid',
      'Bangalore',
      'Mumbai',
      'Delhi',
      'Pune',
      'Chennai',
      'Hyderabad',
      'Gurgaon',
      'Noida',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: locations.map((location) {
            final isSelected = (_filters['locations'] as List<dynamic>?)?.contains(location) ?? false;
            return FilterChip(
              label: Text(location),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['locations'] == null) {
                    _filters['locations'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['locations'].add(location);
                  } else {
                    _filters['locations'].remove(location);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceFilter() {
    final experienceLevels = [
      'Entry Level (0-2 years)',
      'Mid Level (3-5 years)',
      'Senior Level (6-8 years)',
      'Lead Level (9+ years)',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Experience Level',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: experienceLevels.map((level) {
            final isSelected = (_filters['experienceLevels'] as List<dynamic>?)?.contains(level) ?? false;
            return FilterChip(
              label: Text(level),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['experienceLevels'] == null) {
                    _filters['experienceLevels'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['experienceLevels'].add(level);
                  } else {
                    _filters['experienceLevels'].remove(level);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildJobTypeFilter() {
    final jobTypes = [
      'Permanent',
      'Contract',
      'Freelance',
      'Internship',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: jobTypes.map((type) {
            final isSelected = (_filters['jobTypes'] as List<dynamic>?)?.contains(type) ?? false;
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['jobTypes'] == null) {
                    _filters['jobTypes'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['jobTypes'].add(type);
                  } else {
                    _filters['jobTypes'].remove(type);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompanyTypeFilter() {
    final companyTypes = [
      'Indian MNC',
      'Foreign MNC',
      'Startup',
      'Product Company',
      'Service Company',
      'Consulting',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Company Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: companyTypes.map((type) {
            final isSelected = (_filters['companyTypes'] as List<dynamic>?)?.contains(type) ?? false;
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['companyTypes'] == null) {
                    _filters['companyTypes'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['companyTypes'].add(type);
                  } else {
                    _filters['companyTypes'].remove(type);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMaternityBenefitsFilter() {
    final benefits = [
      'Extended Maternity Leave',
      'Flexible Working Hours',
      'Remote Work Options',
      'Health Insurance',
      'Childcare Support',
      'Prenatal Care',
      'Mental Health Support',
      'No Pressure Policy',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maternity Benefits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: benefits.map((benefit) {
            final isSelected = (_filters['maternityBenefits'] as List<dynamic>?)?.contains(benefit) ?? false;
            return FilterChip(
              label: Text(benefit),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (_filters['maternityBenefits'] == null) {
                    _filters['maternityBenefits'] = <dynamic>[];
                  }
                  if (selected) {
                    _filters['maternityBenefits'].add(benefit);
                  } else {
                    _filters['maternityBenefits'].remove(benefit);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRemoteWorkFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Remote Work Preference',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              RadioListTile<String>(
                title: const Text('Any'),
                value: 'any',
                groupValue: _filters['remoteWork'] ?? 'any',
                onChanged: (value) {
                  setState(() {
                    _filters['remoteWork'] = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Remote Only'),
                value: 'remote',
                groupValue: _filters['remoteWork'] ?? 'any',
                onChanged: (value) {
                  setState(() {
                    _filters['remoteWork'] = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Hybrid'),
                value: 'hybrid',
                groupValue: _filters['remoteWork'] ?? 'any',
                onChanged: (value) {
                  setState(() {
                    _filters['remoteWork'] = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Office Based'),
                value: 'office',
                groupValue: _filters['remoteWork'] ?? 'any',
                onChanged: (value) {
                  setState(() {
                    _filters['remoteWork'] = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
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
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}

class ApplicationModel {
  final String id;
  final String? jobId; // Made optional since we're using static job data
  final String applicantId;
  final String name;
  final String email;
  final String message;
  final String? resumeUrl;
  final DateTime createdAt;
  
  // Additional fields for job details
  final String jobTitle;
  final String companyName;
  final String status;
  final String location;
  final String salary;

  ApplicationModel({
    required this.id,
    this.jobId, // Made optional
    required this.applicantId,
    required this.name,
    required this.email,
    required this.message,
    this.resumeUrl,
    required this.createdAt,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.location,
    required this.salary,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      jobId: json['job_id'], // Can be null
      applicantId: json['applicant_id'],
      name: json['name'],
      email: json['email'],
      message: json['message'],
      resumeUrl: json['resume_url'],
      createdAt: DateTime.parse(json['created_at']),
      jobTitle: json['job_title'] ?? 'Unknown Job',
      companyName: json['company_name'] ?? 'Unknown Company',
      status: json['status'] ?? 'Applied',
      location: json['location'] ?? 'Remote',
      salary: json['salary'] ?? 'Not specified',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId, // Can be null
      'applicant_id': applicantId,
      'name': name,
      'email': email,
      'message': message,
      'resume_url': resumeUrl,
      'created_at': createdAt.toIso8601String(),
      'job_title': jobTitle,
      'company_name': companyName,
      'status': status,
      'location': location,
      'salary': salary,
    };
  }

  ApplicationModel copyWith({
    String? id,
    String? jobId,
    String? applicantId,
    String? name,
    String? email,
    String? message,
    String? resumeUrl,
    DateTime? createdAt,
    String? jobTitle,
    String? companyName,
    String? status,
    String? location,
    String? salary,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      applicantId: applicantId ?? this.applicantId,
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      createdAt: createdAt ?? this.createdAt,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      status: status ?? this.status,
      location: location ?? this.location,
      salary: salary ?? this.salary,
    );
  }
}

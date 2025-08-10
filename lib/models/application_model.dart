class ApplicationModel {
  final String id;
  final String jobId;
  final String applicantId;
  final String name;
  final String email;
  final String message;
  final String? resumeUrl;
  final DateTime createdAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.name,
    required this.email,
    required this.message,
    this.resumeUrl,
    required this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      jobId: json['job_id'],
      applicantId: json['applicant_id'],
      name: json['name'],
      email: json['email'],
      message: json['message'],
      resumeUrl: json['resume_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'applicant_id': applicantId,
      'name': name,
      'email': email,
      'message': message,
      'resume_url': resumeUrl,
      'created_at': createdAt.toIso8601String(),
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
    );
  }
}

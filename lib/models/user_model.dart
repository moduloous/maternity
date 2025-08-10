enum UserRole { jobSeeker, employer }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final List<String>? skills;
  final String? experience;
  final bool? maternityStatus;
  final String? resumeUrl;
  final String? companyName;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.skills,
    this.experience,
    this.maternityStatus,
    this.resumeUrl,
    this.companyName,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.jobSeeker,
      ),
      skills: json['skills'] != null 
          ? List<String>.from(json['skills'])
          : null,
      experience: json['experience'],
      maternityStatus: json['maternity_status'],
      resumeUrl: json['resume_url'],
      companyName: json['company_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'skills': skills,
      'experience': experience,
      'maternity_status': maternityStatus,
      'resume_url': resumeUrl,
      'company_name': companyName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    List<String>? skills,
    String? experience,
    bool? maternityStatus,
    String? resumeUrl,
    String? companyName,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      maternityStatus: maternityStatus ?? this.maternityStatus,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

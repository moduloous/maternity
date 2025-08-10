enum JobType { fullTime, partTime, remote, contract }

class JobModel {
  final String id;
  final String title;
  final String company;
  final JobType type;
  final String description;
  final bool maternityFriendly;
  final String employerId;
  final DateTime createdAt;
  final bool isSaved;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.type,
    required this.description,
    required this.maternityFriendly,
    required this.employerId,
    required this.createdAt,
    this.isSaved = false,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      type: JobType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => JobType.fullTime,
      ),
      description: json['description'],
      maternityFriendly: json['maternity_friendly'] ?? false,
      employerId: json['employer_id'],
      createdAt: DateTime.parse(json['created_at']),
      isSaved: json['is_saved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'type': type.toString().split('.').last,
      'description': description,
      'maternity_friendly': maternityFriendly,
      'employer_id': employerId,
      'created_at': createdAt.toIso8601String(),
      'is_saved': isSaved,
    };
  }

  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    JobType? type,
    String? description,
    bool? maternityFriendly,
    String? employerId,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      type: type ?? this.type,
      description: description ?? this.description,
      maternityFriendly: maternityFriendly ?? this.maternityFriendly,
      employerId: employerId ?? this.employerId,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  String get typeDisplay {
    switch (type) {
      case JobType.fullTime:
        return 'Full Time';
      case JobType.partTime:
        return 'Part Time';
      case JobType.remote:
        return 'Remote';
      case JobType.contract:
        return 'Contract';
    }
  }
}

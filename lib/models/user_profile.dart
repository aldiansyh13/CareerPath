class UserProfile {
  final String name;
  final String major;
  final int semester;

  const UserProfile({required this.name, required this.major, required this.semester});

  Map<String, dynamic> toJson() => {
        'name': name,
        'major': major,
        'semester': semester,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: (json['name'] ?? '') as String,
      major: (json['major'] ?? '') as String,
      semester: (json['semester'] as num?)?.toInt() ?? 0,
    );
  }
}

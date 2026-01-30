class User {
  final String id;
  final String name;
  final String email;
  final String userType; // 'learner' or 'admin'
  final String? profileImage;
  final DateTime? joinDate;
  final List<String>? enrolledPrograms;
  final Map<String, dynamic>? achievements;
  // Additional fields
  final String? phone;
  final String? bio;
  final String? education;
  final String? experience;
  final List<String>? skills;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.profileImage,
    this.joinDate,
    this.enrolledPrograms,
    this.achievements,
    this.phone,
    this.bio,
    this.education,
    this.experience,
    this.skills,
    this.createdAt,
  });

  // Getter for role (backward compatibility)
  String get role => userType;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['userType'] ?? json['role'] ?? 'learner',
      profileImage: json['profileImage'],
      joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      enrolledPrograms: List<String>.from(json['enrolledPrograms'] ?? []),
      achievements: json['achievements'],
      phone: json['phone'],
      bio: json['bio'],
      education: json['education'],
      experience: json['experience'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType,
      'profileImage': profileImage,
      'joinDate': joinDate?.toIso8601String(),
      'enrolledPrograms': enrolledPrograms,
      'achievements': achievements,
      'phone': phone,
      'bio': bio,
      'education': education,
      'experience': experience,
      'skills': skills,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Default user factory
  factory User.defaultUser() {
    return User(
      id: '0',
      name: 'Guest',
      email: 'guest@example.com',
      userType: 'learner',
    );
  }

  bool get isAdmin => userType == 'admin';
  
  // Factory for creating user with role parameter (backward compatibility)
  factory User.withRole({
    required String id,
    required String name,
    required String email,
    required String role,
    String? profileImage,
    DateTime? joinDate,
    List<String>? enrolledPrograms,
    Map<String, dynamic>? achievements,
    String? phone,
    String? bio,
    String? education,
    String? experience,
    List<String>? skills,
    DateTime? createdAt,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      userType: role,
      profileImage: profileImage,
      joinDate: joinDate,
      enrolledPrograms: enrolledPrograms,
      achievements: achievements,
      phone: phone,
      bio: bio,
      education: education,
      experience: experience,
      skills: skills,
      createdAt: createdAt,
    );
  }
}

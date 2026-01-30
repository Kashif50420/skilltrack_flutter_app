class Program {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration; // in weeks
  final String difficulty; // Beginner, Intermediate, Advanced
  final List<String> skills;
  final List<String> modules;
  final String provider;
  final double rating;
  final int enrolledCount;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic>? requirements;
  final String? imageUrl;
  // Additional fields
  final String? level; // Alias for difficulty
  final double? price;
  final String? instructor;
  final int? enrolledStudents; // Alias for enrolledCount
  final String? detailedDescription;

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.skills,
    required this.modules,
    required this.provider,
    this.rating = 0.0,
    this.enrolledCount = 0,
    this.isActive = true,
    required this.startDate,
    required this.endDate,
    this.requirements,
    this.imageUrl,
    this.level,
    this.price,
    this.instructor,
    this.enrolledStudents,
    this.detailedDescription,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      duration: json['duration'] is int ? json['duration'] : int.tryParse(json['duration'].toString()) ?? 0,
      difficulty: json['difficulty'] ?? json['level'] ?? 'Beginner',
      skills: List<String>.from(json['skills'] ?? []),
      modules: List<String>.from(json['modules'] ?? []),
      provider: json['provider'],
      rating: json['rating']?.toDouble() ?? 0.0,
      enrolledCount: json['enrolledCount'] ?? json['enrolledStudents'] ?? 0,
      isActive: json['isActive'] ?? true,
      startDate: json['startDate'] is DateTime ? json['startDate'] : DateTime.parse(json['startDate']),
      endDate: json['endDate'] is DateTime ? json['endDate'] : DateTime.parse(json['endDate']),
      requirements: json['requirements'],
      imageUrl: json['imageUrl'],
      level: json['level'] ?? json['difficulty'],
      price: json['price']?.toDouble(),
      instructor: json['instructor'],
      enrolledStudents: json['enrolledStudents'] ?? json['enrolledCount'],
      detailedDescription: json['detailedDescription'] ?? json['description'],
    );
  }

  // Factory for fromMap (alias for fromJson)
  factory Program.fromMap(Map<String, dynamic> map) => Program.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'skills': skills,
      'modules': modules,
      'provider': provider,
      'rating': rating,
      'enrolledCount': enrolledCount,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'requirements': requirements,
      'imageUrl': imageUrl,
      'level': level ?? difficulty,
      'price': price,
      'instructor': instructor,
      'enrolledStudents': enrolledStudents ?? enrolledCount,
      'detailedDescription': detailedDescription ?? description,
    };
  }

  // Alias for toJson
  Map<String, dynamic> toMap() => toJson();
}

import 'dart:convert';

class Enrollment {
  final String id;
  final String programId;
  final String learnerId;
  final String? userId;
  final String status;
  final double progress;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final bool isActive;
  final DateTime enrolledDate;

  Enrollment({
    required this.id,
    required this.programId,
    required this.learnerId,
    this.userId,
    this.status = 'active',
    this.progress = 0.0,
    required this.enrolledAt,
    this.completedAt,
    this.isActive = true,
    required this.enrolledDate,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['id']?.toString() ?? '0',
      programId: map['programId']?.toString() ?? '',
      learnerId: map['learnerId']?.toString() ?? '',
      userId: map['userId']?.toString(),
      status: map['status']?.toString() ?? 'active',
      progress: (map['progress'] is num ? map['progress'].toDouble() : 0.0),
      enrolledAt:
          map['enrolledAt'] is DateTime ? map['enrolledAt'] : DateTime.now(),
      completedAt: map['completedAt'] is DateTime ? map['completedAt'] : null,
      isActive: map['isActive'] is bool ? map['isActive'] : true,
      enrolledDate: map['enrolledDate'] is DateTime
          ? map['enrolledDate']
          : DateTime.now(),
    );
  }

  factory Enrollment.fromJson(String source) =>
      Enrollment.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'programId': programId,
      'learnerId': learnerId,
      'userId': userId,
      'status': status,
      'progress': progress,
      'enrolledAt': enrolledAt,
      'completedAt': completedAt,
      'isActive': isActive,
      'enrolledDate': enrolledDate,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Enrollment(id: $id, programId: $programId, learnerId: $learnerId, progress: $progress)';
  }
}

enum GradeType {
  homework,
  quiz,
  exam,
  project,
  participation,
}

class GradeModel {
  final String id;
  final String studentId;
  final String courseId;
  final String teacherId;
  final GradeType type;
  final String title;
  final double maxScore;
  final double score;
  final double weight;
  final DateTime date;
  final String? comments;

  double get percentage => (score / maxScore) * 100;

  GradeModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.teacherId,
    required this.type,
    required this.title,
    required this.maxScore,
    required this.score,
    this.weight = 1.0,
    required this.date,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'teacherId': teacherId,
      'type': type.name,
      'title': title,
      'maxScore': maxScore,
      'score': score,
      'weight': weight,
      'date': date.millisecondsSinceEpoch,
      'comments': comments,
    };
  }

  factory GradeModel.fromMap(Map<String, dynamic> map) {
    return GradeModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      courseId: map['courseId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      type: GradeType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => GradeType.homework,
      ),
      title: map['title'] ?? '',
      maxScore: (map['maxScore'] as num).toDouble(),
      score: (map['score'] as num).toDouble(),
      weight: (map['weight'] as num?)?.toDouble() ?? 1.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      comments: map['comments'],
    );
  }

  GradeModel copyWith({
    String? title,
    double? maxScore,
    double? score,
    double? weight,
    String? comments,
  }) {
    return GradeModel(
      id: id,
      studentId: studentId,
      courseId: courseId,
      teacherId: teacherId,
      type: type,
      title: title ?? this.title,
      maxScore: maxScore ?? this.maxScore,
      score: score ?? this.score,
      weight: weight ?? this.weight,
      date: date,
      comments: comments ?? this.comments,
    );
  }
}
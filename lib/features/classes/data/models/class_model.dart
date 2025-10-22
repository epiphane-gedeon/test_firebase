class ClassModel {
  final String id;
  final String name;
  final String grade;
  final String? teacherId;
  final int academicYear;
  final int maxStudents;
  final List<String> studentIds;
  final List<String> courseIds;

  ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    this.teacherId,
    required this.academicYear,
    this.maxStudents = 30,
    this.studentIds = const [],
    this.courseIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'teacherId': teacherId,
      'academicYear': academicYear,
      'maxStudents': maxStudents,
      'studentIds': studentIds,
      'courseIds': courseIds,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      grade: map['grade'] ?? '',
      teacherId: map['teacherId'],
      academicYear: map['academicYear'] ?? DateTime.now().year,
      maxStudents: map['maxStudents'] ?? 30,
      studentIds: List<String>.from(map['studentIds'] ?? []),
      courseIds: List<String>.from(map['courseIds'] ?? []),
    );
  }
}
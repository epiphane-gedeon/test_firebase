enum AttendanceStatus {
  present,
  absent,
  late,
  excused,
}

class AttendanceModel {
  final String id;
  final String studentId;
  final String courseId;
  final String classId;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.classId,
    required this.date,
    required this.status,
    this.notes,
    this.checkInTime,
    this.checkOutTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'classId': classId,
      'date': date.millisecondsSinceEpoch,
      'status': status.name,
      'notes': notes,
      'checkInTime': checkInTime?.millisecondsSinceEpoch,
      'checkOutTime': checkOutTime?.millisecondsSinceEpoch,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      courseId: map['courseId'] ?? '',
      classId: map['classId'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      notes: map['notes'],
      checkInTime: map['checkInTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkInTime'])
          : null,
      checkOutTime: map['checkOutTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkOutTime'])
          : null,
    );
  }

  AttendanceModel copyWith({
    AttendanceStatus? status,
    String? notes,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) {
    return AttendanceModel(
      id: id,
      studentId: studentId,
      courseId: courseId,
      classId: classId,
      date: date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }
}
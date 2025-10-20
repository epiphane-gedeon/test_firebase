class CourseModel {
  final String id;
  final String name;
  final String description;
  final String subject;
  final String teacherId;
  final String classId;
  final List<String> studentIds;
  final Schedule schedule;
  final DateTime startDate;
  final DateTime endDate;
  final int creditHours;

  CourseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.subject,
    required this.teacherId,
    required this.classId,
    this.studentIds = const [],
    required this.schedule,
    required this.startDate,
    required this.endDate,
    this.creditHours = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subject': subject,
      'teacherId': teacherId,
      'classId': classId,
      'studentIds': studentIds,
      'schedule': schedule.toMap(),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'creditHours': creditHours,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      subject: map['subject'] ?? '',
      teacherId: map['teacherId'] ?? '',
      classId: map['classId'] ?? '',
      studentIds: List<String>.from(map['studentIds'] ?? []),
      schedule: Schedule.fromMap(Map<String, dynamic>.from(map['schedule'] ?? {})),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      creditHours: map['creditHours'] ?? 1,
    );
  }
}

class Schedule {
  final List<WeekDay> days;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? room;

  Schedule({
    required this.days,
    required this.startTime,
    required this.endTime,
    this.room,
  });

  Map<String, dynamic> toMap() {
    return {
      'days': days.map((day) => day.name).toList(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'room': room,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      days: (map['days'] as List<dynamic>?)
          ?.map((day) => WeekDay.values.firstWhere(
                (e) => e.name == day,
                orElse: () => WeekDay.monday,
              ))
          .toList() ??
          [],
      startTime: _parseTime(map['startTime'] ?? '09:00'),
      endTime: _parseTime(map['endTime'] ?? '10:00'),
      room: map['room'],
    );
  }

  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

// Helper class for TimeOfDay since it's not natively serializable
class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
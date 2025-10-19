class TeacherModel {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final List<String> subjectIds;
  final List<String> classIds;
  final DateTime hireDate;
  final String? department;
  final String? office;

  String get fullName => '$firstName $lastName';

  TeacherModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.subjectIds = const [],
    this.classIds = const [],
    required this.hireDate,
    this.department,
    this.office,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'subjectIds': subjectIds,
      'classIds': classIds,
      'hireDate': hireDate.millisecondsSinceEpoch,
      'department': department,
      'office': office,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      subjectIds: List<String>.from(map['subjectIds'] ?? []),
      classIds: List<String>.from(map['classIds'] ?? []),
      hireDate: DateTime.fromMillisecondsSinceEpoch(map['hireDate']),
      department: map['department'],
      office: map['office'],
    );
  }

  TeacherModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    List<String>? subjectIds,
    List<String>? classIds,
    String? department,
    String? office,
  }) {
    return TeacherModel(
      id: id,
      userId: userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      subjectIds: subjectIds ?? this.subjectIds,
      classIds: classIds ?? this.classIds,
      hireDate: hireDate,
      department: department ?? this.department,
      office: office ?? this.office,
    );
  }
}
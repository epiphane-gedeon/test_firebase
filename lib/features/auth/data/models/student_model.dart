class StudentModel {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String? parentEmail;
  final String classId;
  final DateTime enrollmentDate;
  final DateTime? dateOfBirth;
  final String? address;
  final String? phoneNumber;

  String get fullName => '$firstName $lastName';

  StudentModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.parentEmail,
    required this.classId,
    required this.enrollmentDate,
    this.dateOfBirth,
    this.address,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'parentEmail': parentEmail,
      'classId': classId,
      'enrollmentDate': enrollmentDate.millisecondsSinceEpoch,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      parentEmail: map['parentEmail'],
      classId: map['classId'] ?? '',
      enrollmentDate: DateTime.fromMillisecondsSinceEpoch(map['enrollmentDate']),
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'])
          : null,
      address: map['address'],
      phoneNumber: map['phoneNumber'],
    );
  }

  StudentModel copyWith({
    String? firstName,
    String? lastName,
    String? parentEmail,
    String? classId,
    String? address,
    String? phoneNumber,
  }) {
    return StudentModel(
      id: id,
      userId: userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      parentEmail: parentEmail ?? this.parentEmail,
      classId: classId ?? this.classId,
      enrollmentDate: enrollmentDate,
      dateOfBirth: dateOfBirth,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
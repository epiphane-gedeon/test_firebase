class SubjectModel {
  final String id;
  final String name;
  final String description;
  final String department;
  final int creditHours;
  final List<String> prerequisiteIds;

  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.department,
    this.creditHours = 1,
    this.prerequisiteIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'department': department,
      'creditHours': creditHours,
      'prerequisiteIds': prerequisiteIds,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      department: map['department'] ?? '',
      creditHours: map['creditHours'] ?? 1,
      prerequisiteIds: List<String>.from(map['prerequisiteIds'] ?? []),
    );
  }
}
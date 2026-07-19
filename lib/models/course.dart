class Course {
  final String? id;
  final String name;
  final String code;
  final String department;
  final String description;
  final String credits;

  const Course({
    this.id,
    required this.name,
    required this.code,
    required this.department,
    this.description = '',
    this.credits = '3',
  });

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      name: (map['courseName'] ?? map['name'] ?? '').toString(),
      code: (map['courseCode'] ?? map['code'] ?? '').toString(),
      department: (map['department'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      credits: (map['credits'] ?? '3').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseName': name.trim(),
      'courseCode': code.trim(),
      'department': department.trim(),
      'description': description.trim(),
      'credits': credits.trim(),
    };
  }
}

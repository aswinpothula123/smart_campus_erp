class Teacher {
  final String? id;

  final String name;
  final String employeeId;
  final String department;
  final String subject;
  final String email;
  final String phone;
  final String qualification;
  final String experience;
  final String photoUrl;

  const Teacher({
    this.id,
    required this.name,
    required this.employeeId,
    required this.department,
    required this.subject,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.experience,
    required this.photoUrl,
  });

  factory Teacher.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return Teacher(
      id: id,
      name: (map["name"] ?? "").toString(),
      employeeId: (map["employeeId"] ?? "").toString(),
      department: (map["department"] ?? "").toString(),
      subject: (map["subject"] ?? "").toString(),
      email: (map["email"] ?? "").toString(),
      phone: (map["phone"] ?? "").toString(),
      qualification: (map["qualification"] ?? "").toString(),
      experience: (map["experience"] ?? "").toString(),
      photoUrl: (map["photoUrl"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name.trim(),
      "employeeId": employeeId.trim(),
      "department": department.trim(),
      "subject": subject.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
      "qualification": qualification.trim(),
      "experience": experience.trim(),
      "photoUrl": photoUrl.trim(),
    };
  }
}
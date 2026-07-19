class Student {
  final String? id;
  final String name;
  final String rollNo;
  final String department;
  final String semester;
  final String email;
  final String phone;
  final String photoUrl;
  final String fatherName;
  final String motherName;
  final String dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String address;
  final String cgpa;

  const Student({
    this.id,
    required this.name,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.fatherName,
    required this.motherName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.address,
    required this.cgpa,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) => Student(
        id: id,
        name: map['name'] ?? '',
        rollNo: map['rollNo'] ?? '',
        department: map['department'] ?? '',
        semester: map['semester'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        photoUrl: map['photoUrl'] ?? '',
        fatherName: map['fatherName'] ?? '',
        motherName: map['motherName'] ?? '',
        dateOfBirth: map['dateOfBirth'] ?? '',
        gender: map['gender'] ?? '',
        bloodGroup: map['bloodGroup'] ?? '',
        address: map['address'] ?? '',
        cgpa: map['cgpa'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'rollNo': rollNo,
        'department': department,
        'semester': semester,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'fatherName': fatherName,
        'motherName': motherName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'address': address,
        'cgpa': cgpa,
      };

  Student copyWith({
    String? id, String? name, String? rollNo, String? department,
    String? semester, String? email, String? phone, String? photoUrl,
    String? fatherName, String? motherName, String? dateOfBirth,
    String? gender, String? bloodGroup, String? address, String? cgpa,
  }) => Student(
        id: id ?? this.id, name: name ?? this.name, rollNo: rollNo ?? this.rollNo,
        department: department ?? this.department, semester: semester ?? this.semester,
        email: email ?? this.email, phone: phone ?? this.phone, photoUrl: photoUrl ?? this.photoUrl,
        fatherName: fatherName ?? this.fatherName, motherName: motherName ?? this.motherName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth, gender: gender ?? this.gender,
        bloodGroup: bloodGroup ?? this.bloodGroup, address: address ?? this.address, cgpa: cgpa ?? this.cgpa,
      );
}

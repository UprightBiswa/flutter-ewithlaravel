class Student {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final int status;
  final int roleId;
  final String createdAt;
  final String updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      status: json['status'],
      roleId: json['role_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

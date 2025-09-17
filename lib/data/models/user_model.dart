class UserModel {
  final int id;
  final String firstName;
  final String phone;

  UserModel({required this.id, required this.firstName, required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      phone: json['phone_number'] ?? '',
    );
  }
}

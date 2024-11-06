import 'dart:convert';

class User {
  final int id;
  final String userName;
  final String fullName;
  final String email;
  final String? thumbnail;
  final String? phoneNumber;
  final String? address;
  final String password;
  final int isActive;

  User({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    this.thumbnail,
    this.phoneNumber,
    this.address,
    required this.password,
    this.isActive = 1,  // Default value is 1 (active)
  });

  // Factory method to create a User instance from JSON
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] ?? 0,
    userName: json['user_name'] ?? '',
    fullName: json['full_name'] ?? '',
    email: json['email'] ?? '',
    thumbnail: json['thumbnail'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
    address: json['address'] ?? '',
    password: json['password'] ?? '',
    isActive: (json['is_active'] is Map && json['is_active']['data'] is List)
        ? (json['is_active']['data'][0] == 1 ? 1 : 0)
        : 0,
  );
}

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'full_name': fullName,
      'email': email,
      'thumbnail': thumbnail,
      'phone_number': phoneNumber,
      'address': address,
      'password': password,
      'is_active': isActive,
    };
  }
}

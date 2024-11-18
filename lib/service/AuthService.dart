import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth/login_screen.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/api/user'; 

  // Đăng nhập
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),  // Dùng baseUrl với endpoint login
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return token;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Đăng ký
  Future<void> register(String fullName, String email, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),  // Dùng baseUrl với endpoint register
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Đăng xuất
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Thay đổi mật khẩu
  Future<void> changePassword(String oldPassword, String newPassword, String confirmNewPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),  // Dùng baseUrl với endpoint change-password
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.body}');
    }
  }

  // Lấy thông tin người dùng
  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),  // Dùng baseUrl với endpoint profile
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final profileData = jsonDecode(response.body);
      return profileData;
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),  // Dùng baseUrl với endpoint profile
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}

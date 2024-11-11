import 'dart:convert'; // Để xử lý JSON
import 'package:http/http.dart' as http; // Thư viện HTTP để gọi API
import 'package:flutter/material.dart'; // Thư viện Flutter để sử dụng BuildContext
import 'package:shared_preferences/shared_preferences.dart'; // Thư viện để lưu trữ dữ liệu cục bộ
import '../screens/auth/login_screen.dart';

class AuthService {
  final String _loginUrl = 'http://10.0.2.2:3000/api/user/login'; // URL API đăng nhập
  final String _registerUrl = 'http://10.0.2.2:3000/api/user/register'; // URL API đăng ký
  final String _changePasswordUrl = 'http://10.0.2.2:3000/api/user/change-password'; // URL API đổi mật khẩu

  Future<String?> login(String email, String password) async {
    final url = Uri.parse(_loginUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return token; // Trả về token nếu thành công
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (error) {
      print('Error during login: $error');
      throw error;
    }
  }

  Future<void> register(String fullName, String email, String password, BuildContext context) async {
    final url = Uri.parse(_registerUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (error) {
      print('Error during registration: $error');
      throw error;
    }
  }

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');

  // Xóa tất cả các route trước đó và chuyển đến LoginScreen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (Route<dynamic> route) => false, // Loại bỏ tất cả các route cũ
  );
}


  Future<void> changePassword(String oldPassword, String newPassword, String confirmNewPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse(_changePasswordUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Gửi token trong header
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Đổi mật khẩu thành công
        return;
      } else {
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (error) {
      print('Error during password change: $error');
      throw error;
    }
  }
}

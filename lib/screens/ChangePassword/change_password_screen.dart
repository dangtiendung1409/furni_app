import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/constants.dart';
import '../../service/AuthService.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _currentPasswordError;
  String? _newPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white), // Đặt màu chữ là trắng
        ),
        backgroundColor: kprimaryColor,
         iconTheme: IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
            if (_currentPasswordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _currentPasswordError!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'New Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirm New Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
            if (_newPasswordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _newPasswordError!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                _changePassword();
              },
              child: const Text(
                'Change Password',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    setState(() {
      _currentPasswordError = null; // Reset lỗi
      _newPasswordError = null; // Reset lỗi
    });

    if (currentPassword.isEmpty) {
      setState(() {
        _currentPasswordError = 'Current password is required';
      });
      return; // Ngừng xử lý nếu mật khẩu hiện tại không được nhập
    }

    if (newPassword.isEmpty) {
      setState(() {
        _newPasswordError = 'New password is required';
      });
      return; // Ngừng xử lý nếu mật khẩu mới không được nhập
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _newPasswordError = 'New password and confirm password do not match';
      });
      return; // Ngừng xử lý nếu mật khẩu mới và xác nhận không khớp
    }

    try {
      await _authService.changePassword(currentPassword, newPassword, confirmPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
    } catch (error) {
      if (error.toString().contains("Invalid token")) {
        setState(() {
          _currentPasswordError = 'Current password is incorrect';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }
}

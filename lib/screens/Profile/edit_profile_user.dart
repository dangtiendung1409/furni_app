import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../service/AuthService.dart';
import '../Profile/profile.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _profileImage; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker tool

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    // Check if the widget is still mounted before updating state
    if (!mounted) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      String? base64Image;
      if (_profileImage != null) {
        final imageBytes = await _profileImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final updatedData = {
        'full_name': _nameController.text.isEmpty ? null : _nameController.text,
        'email': _emailController.text.isEmpty ? null : _emailController.text,
        'phone_number':
            _phoneController.text.isEmpty ? null : _phoneController.text,
        'address':
            _addressController.text.isEmpty ? null : _addressController.text,
        'thumbnail': base64Image,
      };

      updatedData.removeWhere((key, value) => value == null);

      await AuthService().updateProfile(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Quay lại màn hình Profile và làm mới
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
        (route) => false, // Xóa toàn bộ stack màn hình
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white), // Title text color
        ),
        backgroundColor: kprimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: _pickImage, // Open image picker on tap
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(
                          _profileImage!) // Hiển thị ảnh người dùng chọn
                      : null, // Không hiển thị ảnh mặc định

                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Full Name TextField
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number TextField
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Address TextField
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                onPressed: _saveProfile, // Call save profile method
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../Profile/edit_profile_user.dart';
import '../../constants.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả sử đây là dữ liệu người dùng bạn sẽ lấy từ cơ sở dữ liệu hoặc API
    final String fullName = "Winnie Vasquez";
    final String email = "winnie@example.com";
    final String phoneNumber = "+123456789";
    final String address = "123 Street, City, Country";
    final String profileImage = "images/profile3.png"; // Đường dẫn ảnh

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: kprimaryColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(profileImage),
              ),
              
              const SizedBox(height: 20),

              // Full Name
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),

              // Email
              Row(
                children: [
                  const Icon(Icons.email, color: kprimaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      email,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Phone Number
              Row(
                children: [
                  const Icon(Icons.phone, color: kprimaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      phoneNumber,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Address
              Row(
                children: [
                  const Icon(Icons.location_on, color: kprimaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Edit Profile Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  // Điều hướng tới trang cập nhật thông tin cá nhân
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileUser()),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

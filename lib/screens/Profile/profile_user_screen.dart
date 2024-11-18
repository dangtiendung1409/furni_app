import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../Profile/edit_profile_user.dart';
import '../../service/AuthService.dart';
import '../../models/user.dart'; // Import the User model

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({super.key});

  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  late Future<Map<String, dynamic>> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = AuthService().getProfile();
  }

  @override
  Widget build(BuildContext context) {
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture, // Fetch profile data from the server
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data available'));
          } else {
            final profileData = snapshot.data!;

            // Convert the profile data to a User object
            final user = User.fromJson(profileData);

            final String fullName = user.fullName ?? 'Unknown';
            final String email = user.email ?? 'No email';
            final String phoneNumber = user.phoneNumber ?? 'No phone number';
            final String address = user.address ?? 'No address';
            final String profileImageBase64 = user.thumbnail ?? ''; // Base64 image data

            // Decode the base64 image data if available
            ImageProvider profileImage = const AssetImage("images/profile3.png"); // Default image
            if (profileImageBase64.isNotEmpty) {
              try {
                final decodedImage = base64Decode(profileImageBase64);
                profileImage = MemoryImage(decodedImage);
              } catch (e) {
                print('Error decoding base64 image: $e');
              }
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImage, // Use decoded image or default image
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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileUser()),
                        );

                        // Nếu result là true, gọi lại setState để làm mới dữ liệu
                        if (result == true) {
                          setState(() {
                            _profileDataFuture = AuthService().getProfile(); // Lấy lại dữ liệu mới
                          });
                        }
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
            );
          }
        },
      ),
    );
  }
}

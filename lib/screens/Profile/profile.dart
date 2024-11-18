import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../OrderStatusPage/order_status_page.dart';
import '../ChangePassword/change_password_screen.dart';
import '../Profile/profile_user_screen.dart';
import '../Profile/product_review_page.dart'; 
import '../Profile/return_requests_page.dart';
import '../../constants.dart';
import '../../service/AuthService.dart';
import '../../models/user.dart'; 

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = AuthService().getProfile(); // Lấy dữ liệu ban đầu
  }

  // Làm mới dữ liệu
  void _refreshProfileData() {
    setState(() {
      _profileDataFuture = AuthService().getProfile(); // Lấy dữ liệu mới
    });
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: AuthService().getProfile(), // Get the profile data as Map
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No user data available'));
            } else {
              final profileData = snapshot.data!;

              // Convert the profile data to a User object
              final user = User.fromJson(profileData);

              final String userName = user.fullName ?? 'Unknown';
              final String userEmail = user.email ?? 'No email';
              final String userAvatarBase64 = user.thumbnail ?? '';

              // If avatar is available, decode it from Base64
              Uint8List? userAvatar = userAvatarBase64.isNotEmpty
                  ? base64Decode(userAvatarBase64)
                  : null;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: userAvatar != null
                              ? MemoryImage(
                                  userAvatar) // Display avatar from base64
                              : const AssetImage("images/profile3.jpg")
                                  as ImageProvider, // Default image
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Additional widgets and options
                 Padding(
  padding: const EdgeInsets.symmetric(horizontal: 14),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _buildStatusIcon(
        Icons.hourglass_empty, "Pending", context, 0),
      _buildStatusIcon(
        Icons.check_circle, "Confirmed", context, 1),
      _buildStatusIcon(
        Icons.local_shipping, "In Delivery", context, 2),
      _buildStatusIcon(
        Icons.rate_review, "Reviewed", context, 3,
        navigateToReview: true),
      _buildStatusIcon(
        Icons.refresh, "Return", context, 4, 
        onTap: () {
          // Khi ấn vào icon "Return", chuyển đến trang yêu cầu hoàn trả
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReturnRequestsPage(),
            ),
          );
        },
      ),
    ],
  ),
),

                  const SizedBox(height: 20),
                  // Other profile options
                  _buildProfileOption(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileUserScreen(),
                        ),
                      );
                      if (result == true) {
                        _refreshProfileData(); // Làm mới dữ liệu nếu có cập nhật
                      }
                    },
                  ),

                  _buildProfileOption(
                    context,
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.storage,
                    title: 'Data Saver & Storage',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.security,
                    title: 'Security',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.language,
                    title: 'Language',
                    trailing: const Text("English (US)"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title:
                        const Text('Dark Mode', style: TextStyle(fontSize: 16)),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kprimaryColor,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text(
                                  'Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await AuthService().logout(context);
                                  },
                                  child: const Text('Log Out'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String title,
      VoidCallback? onTap,
      Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

Widget _buildStatusIcon(
    IconData icon, String title, BuildContext context, int tabIndex,
    {bool navigateToReview = false, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap ?? () {
      if (navigateToReview) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductReviewPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderStatusPage(tabIndex: tabIndex),
          ),
        );
      }
    },
      child: Column(
        children: [
          Icon(icon, size: 30, color: kprimaryColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

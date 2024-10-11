import 'package:flutter/material.dart';
import '../OrderStatusPage/order_status_page.dart';
import '../ChangePassword/change_password_screen.dart';
import '../Profile/profile_user_screen.dart';
import '../auth/login_screen.dart';
import '../../constants.dart';
import '../../service/AuthService.dart'; // Nhập AuthService

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        child: Stack(
          children: [
            Image.asset(
              "images/profile3.png",
              fit: BoxFit.cover,
              height: size.height * 0.35,
              width: size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Information Section
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage("images/profile3.png"),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "dung",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                "Flutter Developer",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // View Order Status Button
                      ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: const Text('Order Status'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OrderStatusPage()),
                          );
                        },
                      ),
                      const Divider(),

                      // Update Profile Button
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Update Profile'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileUserScreen()),
                          );
                        },
                      ),
                      const Divider(),

                      // Change Password Button
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Change Password'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                          );
                        },
                      ),
                      const Divider(),

                      // Log Out Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kprimaryColor, 
                          ),
                          onPressed: () {
                            // Hiện hộp thoại xác nhận trước khi đăng xuất
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Log Out'),
                                content: const Text('Are you sure you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Gọi phương thức logout từ AuthService
                                      await AuthService().logout(context);
                                    },
                                    child: const Text('Log Out'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.white, // Màu chữ trắng
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

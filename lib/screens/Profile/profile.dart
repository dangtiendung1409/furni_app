import 'package:flutter/material.dart';
import '../OrderStatusPage/order_status_page.dart';
import '../ChangePassword/change_password_screen.dart';
import '../Profile/profile_user_screen.dart';
import '../../constants.dart';
import '../../service/AuthService.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
        child: Column(
          children: [
            // Các phần nội dung trước đây
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("images/profile3.png"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Andrew Ainsley",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        "andrew_ainsley@yourdomain.com",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
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
            // Thay phần quảng cáo bằng các icon trạng thái đơn hàng
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusIcon(Icons.hourglass_empty, "Pending", context, 0),
                  _buildStatusIcon(Icons.check_circle, "Confirmed", context, 1),
                  _buildStatusIcon(Icons.local_shipping, "In Delivery", context, 2),
                  _buildStatusIcon(Icons.rate_review, "Reviewed", context, 3),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Các phần danh sách chức năng
            _buildProfileOption(
              context,
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileUserScreen()),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.lock, // Biểu tượng thay đổi mật khẩu
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
              icon: Icons.mic,
              title: 'Audio & Video',
              onTap: () {
                // Chức năng âm thanh và video
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.play_circle,
              title: 'Playback',
              onTap: () {
                // Chức năng phát lại
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.storage,
              title: 'Data Saver & Storage',
              onTap: () {
                // Chức năng tiết kiệm dữ liệu và lưu trữ
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                // Chức năng bảo mật
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.language,
              title: 'Language',
              trailing: const Text("English (US)"),
              onTap: () {
                // Chức năng chọn ngôn ngữ
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 16),
              ),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // Chức năng bật tắt chế độ tối
                },
              ),
            ),

            // Đặt nút Log Out cuối cùng mà không dùng Spacer
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
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
                        content:
                            const Text('Are you sure you want to log out?'),
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo ListTile cho các mục
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
}

// Hàm hỗ trợ tạo icon với trạng thái
Widget _buildStatusIcon(IconData icon, String title, BuildContext context, int tabIndex) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến OrderStatusPage và chuyển đến tab tương ứng
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderStatusPage(tabIndex: tabIndex),
          ),
        );
      },
      child: Column(
        children: [
          Icon(icon, size: 30, color: kprimaryColor), // Icon với kích thước và màu sắc
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
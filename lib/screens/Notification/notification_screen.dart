import 'package:flutter/material.dart';
import '../Favorite/favorite_screen.dart';
import '../Cart/cart_screen.dart';
import '../../constants.dart';
import '../nav_bar_screen.dart'; 

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
           fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white, 
          ),
        ),
        backgroundColor: kprimaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white, 
            ),
            onPressed: () {
              // Thay đổi currentIndex để chuyển sang màn hình Favorite
              BottomNavBarState? bottomNavBarState = context.findAncestorStateOfType<BottomNavBarState>();
              bottomNavBarState?.setState(() {
                bottomNavBarState.cuttentIndex = 1; // Chỉ số của màn hình Favorite
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white, 
            ),
            onPressed: () {
              // Thay đổi currentIndex để chuyển sang màn hình Cart
              BottomNavBarState? bottomNavBarState = context.findAncestorStateOfType<BottomNavBarState>();
              bottomNavBarState?.setState(() {
                bottomNavBarState.cuttentIndex = 3; // Chỉ số của màn hình CartScreen
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          NotificationItem(
            title: 'Đơn hàng của bạn đã được giao',
            subtitle: 'Hãy kiểm tra đơn hàng của bạn.',
            timestamp: '12 phút trước',
          ),
          NotificationItem(
            title: 'Giảm giá đặc biệt',
            subtitle: 'Nhận ngay 20% giảm giá cho đơn hàng tiếp theo của bạn!',
            timestamp: '1 giờ trước',
          ),
          // Thêm các thông báo khác ở đây
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        timestamp,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
        // Hành động khi người dùng nhấn vào thông báo
      },
    );
  }
}

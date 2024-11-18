import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/notification.dart' as model;
import '../../service/NotificationService.dart';
import '../../constants.dart';
import '../nav_bar_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<model.Notification> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Token not found. Please log in again.';
      });
      return;
    }

    try {
      final notifications = await _notificationService.fetchNotifications(token);
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  String _formatTimestamp(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

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
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              BottomNavBarState? bottomNavBarState = context.findAncestorStateOfType<BottomNavBarState>();
              bottomNavBarState?.setState(() {
                bottomNavBarState.cuttentIndex = 1;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              BottomNavBarState? bottomNavBarState = context.findAncestorStateOfType<BottomNavBarState>();
              bottomNavBarState?.setState(() {
                bottomNavBarState.cuttentIndex = 3;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return NotificationItem(
                      title: notification.title,
                      subtitle: notification.message,
                      timestamp: _formatTimestamp(notification.created_at), 
                    );
                  },
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
        style: const TextStyle(fontWeight: FontWeight.bold),
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
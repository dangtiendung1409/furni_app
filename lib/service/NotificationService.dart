import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification.dart'; 
import '../models/user.dart'; 
import '../models/order.dart'; 

class NotificationService {
  final String baseUrl = 'http://10.0.2.2:3000/api/notification';

  // Hàm lấy danh sách thông báo cho người dùng
  Future<List<Notification>> fetchNotifications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getNotifications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> notifications = body['data'];
        // Chuyển đổi danh sách thông báo thành đối tượng Notification
        return notifications.map<Notification>((notificationJson) {
          return Notification.fromJson(notificationJson);
        }).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}

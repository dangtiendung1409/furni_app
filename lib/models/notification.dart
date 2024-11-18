import 'dart:convert';
import './user.dart';
import './order.dart';

class Notification {
  final int id;
  final User user; 
  final Order? order; 
  final String title; 
  final String message; 
  final DateTime created_at; 

  Notification({
    required this.id,
    required this.user,
    this.order,
    required this.title, 
    required this.message,
    required this.created_at,
  });

  // Phương thức tính toán từ JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
      title: json['title'] ?? '', 
      message: json['message'] ?? '',
      created_at: DateTime.parse(json['created_at'] ?? ''),
    );
  }

  // Phương thức chuyển đổi đối tượng Notification thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'order': order?.toJson(),
      'title': title, 
      'message': message,
      'created_at': created_at.toIso8601String(),
    };
  }
}

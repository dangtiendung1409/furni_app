import 'dart:convert';
import './product.dart';

class Favorite {
  final int productId;
  final int userId;
  Product? product; // Thêm trường này

  Favorite({
    required this.productId,
    required this.userId,
    this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      productId: json['product_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'user_id': userId,
    };
  }
}

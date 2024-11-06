import 'dart:convert';
import './product.dart';
import './user.dart';

class Cart {
  final int id;
  final User user; // Người dùng
  final Product product; // Sản phẩm
  final int qty; // Số lượng sản phẩm
  final double total; // Tổng giá trị sản phẩm

  Cart({
    required this.id,
    required this.user,
    required this.product,
    required this.qty,
    required this.total,
  });
double get totalPrice {
  return (product.price ?? 0.0) * qty;
}
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}), // Kiểm tra nếu user là null
      product: Product.fromJson(json['product'] ?? {}), // Kiểm tra nếu product là null
      qty: (json['qty'] is int) ? json['qty'] : (json['qty'] is double) ? json['qty'].toInt() : 0,
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'product': product.toJson(),
      'qty': qty,
      'total': total,
    };
  }
}

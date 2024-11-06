import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../models/product.dart'; // Import class Product nếu chưa có

class CartService {
  final String baseUrl = 'http://10.0.2.2:3000/api/cart'; // Địa chỉ API cơ bản

  // Hàm lấy giỏ hàng của người dùng
  Future<List<Cart>> fetchCart(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getCart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Đảm bảo sử dụng token hợp lệ
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];

        // Chuyển đổi dữ liệu giỏ hàng và sản phẩm thành các đối tượng Cart với Product đầy đủ thông tin
        return content.map<Cart>((item) {
          // Chuyển đổi mỗi phần tử thành Cart và Product
          Product product = Product.fromJson(item['product']);
          return Cart.fromJson({
            'id': item['id'],
            'product': product.toJson(), // Cung cấp dữ liệu sản phẩm đầy đủ
            'qty': item['qty'],
            'total': item['total'],
          });
        }).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  Future<Cart> addToCart(int productId, int qty, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addToCart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Đảm bảo sử dụng token hợp lệ
      },
      body: json.encode({
        'product_id': productId,
        'qty': qty,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Cart.fromJson(body['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  // Hàm cập nhật sản phẩm trong giỏ hàng
  Future<Cart> updateCart(int productId, int qty, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateCart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Đảm bảo sử dụng token hợp lệ
      },
      body: json.encode({
        'product_id': productId,
        'qty': qty,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Cart.fromJson(body['data']);
    } else {
      throw Exception('Failed to update cart');
    }
  }

// Hàm xóa sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(int productId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/removeFromCart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'product_id': productId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }
}

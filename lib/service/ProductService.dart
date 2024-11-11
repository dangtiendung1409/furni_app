import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = 'http://10.0.2.2:3000/api/product';

  // Hàm lấy sản phẩm theo danh mục
  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$categoryId'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load products for category $categoryId');
    }
  }

  // Hàm lấy một sản phẩm theo ID
  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/productDetail/$id'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Product.fromJson(body['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Hàm lấy sản phẩm liên quan
  Future<List<Product>> fetchRelatedProducts(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/related/$productId'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load related products for product $productId');
    }
  }

  // hàm giảm qty khi đặt order thành công
  Future<void> updateProductQuantity(
      String token, int productId, int qtyInCart) async {
    // Lấy thông tin sản phẩm trước khi giảm số lượng
    final productResponse = await http.get(
      Uri.parse('$baseUrl/productDetail/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (productResponse.statusCode != 200) {
      throw Exception('Failed to load product');
    }

    final product = jsonDecode(productResponse.body);

    // Lấy số lượng hiện tại của sản phẩm
    int currentQty = product['data']['qty'];

    // Trừ số lượng trong giỏ hàng vào số lượng hiện tại
    int updatedQty = currentQty - qtyInCart;

    // Gửi yêu cầu cập nhật số lượng sản phẩm
    final response = await http.patch(
      Uri.parse('$baseUrl/updateQty/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "qty": qtyInCart, // Chỉ cần gửi số lượng từ giỏ hàng
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product quantity');
    }
  }
  // Hàm tìm kiếm sản phẩm theo tên
  Future<List<Product>> fetchProductsByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/search?name=$name'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load products for name $name');
    }
  }
}

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

    // Kiểm tra xem body có phải là một Map không
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      List<dynamic> content = body['data'];
      List<Product> products = content.map((item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to load products for category $categoryId');
  }
}


  // Hàm lấy một sản phẩm theo ID
  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}

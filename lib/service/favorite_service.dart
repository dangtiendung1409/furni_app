import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/favorite.dart';
import '../models/product.dart';

class FavoriteService {
  final String baseUrl = 'http://10.0.2.2:3000/api/favorite';

  // Hàm lấy danh sách yêu thích của người dùng
 
  Future<List<Favorite>> fetchFavorites(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/getFavorites'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    if (body is Map<String, dynamic> && body.containsKey('data')) {
      List<dynamic> content = body['data'];

      return content.map<Favorite>((item) {
        Product product = Product.fromJson(item['product']);
        return Favorite.fromJson({
          'product_id': product.id,
          'user_id': item['user_id'],
        })..product = product; 
      }).toList();
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to load favorites');
  }
}
  // Hàm thêm sản phẩm vào danh sách yêu thích
  Future<Favorite> addToFavorite(int productId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addToFavorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'product_id': productId,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Favorite.fromJson(body['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to add to favorites');
    }
  }

  // Hàm xóa sản phẩm khỏi danh sách yêu thích
  Future<void> removeFromFavorite(int productId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/removeFromFavorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'product_id': productId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from favorites');
    }
  }
}

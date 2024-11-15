import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/orderProduct.dart';
import '../models/review.dart';

class ReviewService {
  final String baseUrl = 'http://10.0.2.2:3000/api/review';

  // Hàm lấy danh sách sản phẩm có thể đánh giá của người dùng
  Future<List<OrderProduct>> fetchReviewableProducts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getReviewableProducts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("API Response: $body"); // In ra dữ liệu nhận được từ API

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map<OrderProduct>((item) {
          Product product = Product.fromJson(item['product']);
          return OrderProduct.fromJson({
            'orderId': item['orderId'],
            'productId': item['productId'],
            'qty': item['qty'],
            'price': item['price'],
            'product': product.toJson(),
          });
        }).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load reviewable products');
    }
  }

  Future<Review> postReview(
      String token, int productId, int ratingValue, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/postReview'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'productId': productId,
        'ratingValue': ratingValue,
        'comment': comment,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body);
      print("API Response: $body");

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Review.fromJson(body['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      print("Error status code: ${response.statusCode}");
      print("Error response body: ${response.body}");
      throw Exception('Failed to post review');
    }
  }

  // Hàm lấy các review được phê duyệt của người dùng hiện tại
  Future<List<Review>> fetchApprovedReviews(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getApprovedReviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("API Response: $body");

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map<Review>((item) => Review.fromJson(item)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load approved reviews');
    }
  }
   Future<List<Review>> fetchReviewsByProductId(String token, int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getReviewsByProductId/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("API Response: $body");

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map<Review>((item) => Review.fromJson(item['review'])).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load reviews for the product');
    }
  }
}

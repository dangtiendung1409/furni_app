import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orderReturn.dart';
import '../models/returnImages.dart';

class OrderReturnService {
  final String baseUrl = 'http://10.0.2.2:3000/api/order-return';

  // Hàm tạo yêu cầu hoàn trả
  Future<OrderReturn> createOrderReturn(
    String token,
    int orderId,
    int productId,
    int qty,
    String reason,
    double returnAmount,
    String description,
    List<String> images,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'order_id': orderId,
        'product_id': productId,
        'qty': qty,
        'reason': reason,
        'return_amount': returnAmount,
        'description': description,
        'images': images,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body.containsKey('data')) {
        final data = body['data'];
        OrderReturn orderReturn = OrderReturn.fromJson(data['orderReturn']);
        List<ReturnImage> returnImages = (data['images'] as List)
            .map((item) => ReturnImage.fromJson(item))
            .toList();

        // Trả về OrderReturn và danh sách hình ảnh
        return orderReturn;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to create order return');
    }
  }
Future<List<OrderReturn>> fetchOrderReturnList(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/list'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    if (body is! Map || !body.containsKey('data') || body['data'] is! List) {
      throw Exception('Dữ liệu trả về không hợp lệ.');
    }

    final List<dynamic> data = body['data'];
    return data.map((item) => OrderReturn.fromJson(item as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to fetch order returns');
  }
}

Future<OrderReturn> fetchOrderReturnDetails(String token, int id) async {
  final response = await http.get(
    Uri.parse('$baseUrl/details/$id'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      final data = body['data'];  // Access the 'data' object
      if (data is Map<String, dynamic>) {
        // Make sure the 'data' object is a Map
        return OrderReturn.fromJson(data);
      } else {
        throw Exception('Expected a Map for order return data');
      }
    } else {
      throw Exception('Response does not contain valid data');
    }
  } else {
    final body = json.decode(response.body);
    throw Exception('Error: ${body['message']}');
  }
}
}

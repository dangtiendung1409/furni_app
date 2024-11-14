import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart'; // Import model Order
import '../models/orderProduct.dart'; // Import model OrderProduct nếu có

class OrderService {
  final String baseUrl = 'http://10.0.2.2:3000/api/order';

  // Hàm tạo đơn hàng
  Future<Order> createOrder({
    required String token,
    required Map<String, dynamic> orderDetails,
    required List<Map<String, dynamic>> products,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createOrder'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Đảm bảo token hợp lệ
      },
      body: json.encode({
        'orderDetails': orderDetails,
        'products': products,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Order.fromJson(body['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to create order');
    }
  }

  // Hàm lấy thông tin đơn hàng theo status
  Future<List<Order>> fetchOrders(String token, String status) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getOrdersByStatus?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content.map<Order>((item) => Order.fromJson(item)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  // Hàm lấy thông tin chi tiết đơn hàng theo orderId
  // Hàm lấy thông tin chi tiết đơn hàng theo orderId (bao gồm cả OrderProduct)
  Future<Order> fetchOrderById(String token, int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getOrderById?orderId=$orderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Order.fromJson(
            body['data']); // Trả về thông tin đơn hàng và các sản phẩm nếu có
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load order: ${response.body}');
    }
  }

  // Hàm lấy thông tin OrderProduct theo orderId
  Future<List<OrderProduct>> fetchOrderProductsById(
      String token, int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getOrderProductsByOrderId?orderId=$orderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        List<dynamic> content = body['data'];
        return content
            .map<OrderProduct>((item) => OrderProduct.fromJson(item))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load order products: ${response.body}');
    }
  }

// Hàm cập nhật trạng thái đơn hàng
  Future<Order> updateOrderStatus({
    required String token,
    required int orderId,
    required String newStatus,
    String? cancelReason, // Optional, chỉ cần thiết khi trạng thái là "cancel"
  }) async {
    // Tạo body với orderId và newStatus
    final Map<String, dynamic> body = {
      'orderId': orderId,
      'newStatus': newStatus,
    };

    // Chỉ thêm cancelReason nếu trạng thái là "Cancel" và cancelReason không null
    if (newStatus == 'cancel' && cancelReason != null) {
      body['cancelReason'] = cancelReason;
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/updateStatus'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('data')) {
        return Order.fromJson(body['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to update order status: ${response.body}');
    }
  }
}

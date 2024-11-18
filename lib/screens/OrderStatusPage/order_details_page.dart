import 'dart:convert';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/order.dart';
import '../../models/orderProduct.dart';
import '../../service/OrderService.dart';
import 'cancel_order_reason_page.dart';
import 'package:intl/intl.dart';
import '../OrderStatusPage/return_order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<Order?> _orderFuture =
      Future.value(); // Initialize as Future of nullable Order
  late Future<List<OrderProduct>?> _orderProductsFuture =
      Future.value(); // Initialize as Future of nullable List
  late String _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchOrder();
  }

  Future<void> _loadTokenAndFetchOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    if (_token.isNotEmpty) {
      setState(() {
        _orderFuture =
            OrderService().fetchOrderById(_token, int.parse(widget.orderId));
        _orderProductsFuture = OrderService()
            .fetchOrderProductsById(_token, int.parse(widget.orderId));
      });
    } else {
      throw Exception("Token không hợp lệ.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: kprimaryColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<Order?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Không có dữ liệu đơn hàng.'));
          } else {
            final order = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildShippingStatus(order),
                  const SizedBox(height: 10),
                  _buildCustomerInfoSection(context, order),
                  const SizedBox(height: 10),
                  FutureBuilder<List<OrderProduct>?>(
                    future: _orderProductsFuture,
                    builder: (context, productSnapshot) {
                      if (productSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (productSnapshot.hasError) {
                        return Text('Lỗi: ${productSnapshot.error}');
                      } else if (!productSnapshot.hasData ||
                          productSnapshot.data == null ||
                          productSnapshot.data!.isEmpty) {
                        return const Text(
                            'Không có sản phẩm cho đơn hàng này.');
                      } else {
                        final products = productSnapshot.data!;
                        return _buildProductInfoSection(
                            context, products, snapshot.data!.status, order.id);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOrderInfoSection(order),
                  const SizedBox(height: 20), // Space before the button
                  // Hiển thị nút huỷ nếu đơn hàng có trạng thái "Pending"
                  if (order.status == 'pending')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Màu nền đỏ
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Điều hướng đến trang lý do hủy đơn hàng
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CancelOrderReasonPage(orderId: widget.orderId),
                          ),
                        );
                      },
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(color: Colors.white), // Màu chữ trắng
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Shipping Status Section
  Widget _buildShippingStatus(Order order) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping information',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(order.shippingMethod ?? 'Chưa có thông tin vận chuyển'),
          Text(
            order.orderDate != null
                ? 'Date of receipt: ${DateFormat('dd/MM/yyyy').format(order.orderDate!)}'
                : 'Chưa có ngày giao hàng',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  // Customer Information Section
  Widget _buildCustomerInfoSection(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery address',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
              'Full Name: ${order.fullName ?? 'No recipient information available'}'),
          Text(
              'Phone Number: ${order.telephone ?? 'No phone number available'}'),
          Text(
            'Address: ${[
                  order.addressDetail,
                  order.ward,
                  order.district,
                  order.province
                ].where((element) => element != null && element.isNotEmpty).join(', ') ?? 'No address available'}',
          ),
        ],
      ),
    );
  }

  // Product Information Section
  Widget _buildProductInfoSection(
    BuildContext context,
    List<OrderProduct> products,
    String orderStatus,
    int orderId,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...products.map((product) {
            double refundAmount = ((product.qty ?? 0) * (product.price ?? 0)) * 0.9;
            return Column(
              children: [
                ListTile(
                  leading: Image.memory(base64Decode(
                      product.product.thumbnail ??
                          'https://via.placeholder.com/50')),
                  title:
                      Text(product.product.productName ?? 'Sản phẩm không tên'),
                  subtitle: Text('Quantity: ${product.qty ?? 0}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Price: \$${product.price}'),
                      // Hiển thị nút replay nếu trạng thái đơn hàng không phải là '1'
                      if (orderStatus != '1')
                        IconButton(
                          icon: Icon(Icons.replay, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReturnOrderPage(
                                  orderId: orderId,
                                  productId: product.productId,
                                  refundAmount: refundAmount,
                                  qty: product.qty ?? 0,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showReturnDialog(BuildContext context, OrderProduct product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Return Product'),
          content: Text(
              'Are you sure you want to return the product: ${product.product.productName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý logic trả lại sản phẩm tại đây
                Navigator.of(context).pop();
              },
              child: Text('Return'),
            ),
          ],
        );
      },
    );
  }

  // Order Information Section
  Widget _buildOrderInfoSection(Order order) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make money: \$${order.totalAmount ?? '0'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('Payment method: ${order.paymentMethod ?? 'Chưa có thông tin'}'),
        ],
      ),
    );
  }
}

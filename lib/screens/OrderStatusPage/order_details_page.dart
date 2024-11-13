import 'dart:convert';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/order.dart';
import '../../models/orderProduct.dart';
import '../../service/OrderService.dart';
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
                        return _buildProductInfoSection(context, products);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOrderInfoSection(order),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(order.shippingMethod ?? 'Chưa có thông tin vận chuyển'),
        Text(order.orderDate?.toString() ?? 'Chưa có ngày giao hàng',
            style: TextStyle(color: Colors.green)),
      ],
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
            'Delivery address', // Tiêu đề tiếng Anh
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(order.fullName ?? 'No recipient information available'),
          Text(order.telephone ?? 'No phone number available'),
          Text(
            [order.addressDetail, order.ward, order.district, order.province]
                    .where((element) => element != null && element.isNotEmpty)
                    .join(', ') ??
                'No address available',
          ),
        ],
      ),
    );
  }

  // Product Information Section
  Widget _buildProductInfoSection(
      BuildContext context, List<OrderProduct> products) {
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
            return Column(
              children: [
                ListTile(
                  leading: Image.memory(base64Decode(product
                          .product.thumbnail ??
                      'https://via.placeholder.com/50')), // Sửa lại thuộc tính `thumbnail`
                  title: Text(product.product.productName ??
                      'Sản phẩm không tên'), // Sửa lại thuộc tính `productName`
                  subtitle: Text('Quanty: ${product.qty ?? 0}'),
                  trailing: Text('Price: \$${product.price}'),
                ),
                const Divider(),
              ],
            );
          }).toList(),
        ],
      ),
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

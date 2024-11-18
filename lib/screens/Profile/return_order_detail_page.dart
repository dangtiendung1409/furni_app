import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/orderReturn.dart';
import '../../constants.dart';
import '../../service/OrderReturnService.dart';
import '../../models/product.dart';

class ReturnOrderDetailPage extends StatefulWidget {
  final int orderReturnId;

  const ReturnOrderDetailPage({super.key, required this.orderReturnId});

  @override
  _ReturnOrderDetailPageState createState() => _ReturnOrderDetailPageState();
}

class _ReturnOrderDetailPageState extends State<ReturnOrderDetailPage> {
  late Future<OrderReturn> _orderReturnDetailFuture;

  @override
  void initState() {
    super.initState();
    _orderReturnDetailFuture = _fetchOrderReturnDetail();
  }

  Future<OrderReturn> _fetchOrderReturnDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token is missing. Please log in again.');
    }

    return await OrderReturnService()
        .fetchOrderReturnDetails(token, widget.orderReturnId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Order Details'),
        backgroundColor: kprimaryColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<OrderReturn>(
        future: _orderReturnDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No return order details found.'));
          } else {
            final orderReturn = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Returned product information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildProductInfo(orderReturn.product), // Hiển thị thông tin sản phẩm
                  const SizedBox(height: 16),
                  _buildInputField('Return Amount', '\$${orderReturn.return_amount?.toStringAsFixed(2) ?? '0.00'}'),
                  _buildInputField('Return Date', orderReturn.return_date?.toLocal().toString().split(' ')[0] ?? 'N/A'),
                  _buildInputField('Reason for Return', orderReturn.reason ?? 'No reason provided'),
                  _buildInputField('Description', orderReturn.description ?? 'No description provided'),
                  const SizedBox(height: 16),
                  if (orderReturn.images != null && orderReturn.images!.isNotEmpty) ...[
                    const Text(
                      'Images:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: orderReturn.images!.length,
                      itemBuilder: (context, index) {
                        final imagePath = orderReturn.images![index].imagePath;
                        final decodedImage = base64Decode(imagePath);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(decodedImage, fit: BoxFit.cover),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.thumbnail != null) // Kiểm tra xem có ảnh không
             ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.memory(
                  base64Decode(product.thumbnail!), // Chuyển base64 thành byte data
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName ?? 'N/A',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4), // Khoảng cách giữa label và input
          TextField(
            readOnly: true, // Chỉ đọc để không cho phép chỉnh sửa
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            ),
            controller: TextEditingController(text: initialValue),
          ),
        ],
      ),
    );
  }
}
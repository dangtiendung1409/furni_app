import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../models/orderReturn.dart';
import '../../service/OrderReturnService.dart';
import 'return_order_detail_page.dart'; // Import trang chi tiết

class ReturnRequestsPage extends StatefulWidget {
  const ReturnRequestsPage({super.key});

  @override
  _ReturnRequestsPageState createState() => _ReturnRequestsPageState();
}

class _ReturnRequestsPageState extends State<ReturnRequestsPage> {
  late Future<List<OrderReturn>> _orderReturnListFuture;

  @override
  void initState() {
    super.initState();
    _orderReturnListFuture = _loadTokenAndFetchData();
  }

  Future<List<OrderReturn>> _loadTokenAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString('token') ?? ''; // Lấy token từ SharedPreferences
    if (token.isNotEmpty) {
      return await OrderReturnService().fetchOrderReturnList(token);
    } else {
      throw Exception('Token not found');
    }
  }

  // Hàm để xác định màu của trạng thái
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange; // Màu cho pending
      case 'rejected':
        return Colors.red; // Màu cho rejected
      case 'approved':
        return Colors.green; // Màu cho approved
      default:
        return Colors.grey[600]!; // Màu mặc định nếu không có status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Requests'),
        centerTitle: true,
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
      body: FutureBuilder<List<OrderReturn>>(
        future: _orderReturnListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No return requests found'));
          } else {
            final orderReturns = snapshot.data!;
            return ListView.builder(
              itemCount: orderReturns.length,
              itemBuilder: (context, index) {
                final orderReturn = orderReturns[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Return Amount: \$${orderReturn.return_amount}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Return Date: ${orderReturn.return_date?.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                print('Order Return ID: ${orderReturn.id}');

                                // Chuyển đến trang chi tiết và truyền id
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReturnOrderDetailPage(
                                        orderReturnId: orderReturn.id),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Thay đổi màu sắc status
                        Text(
                          'Status: ${orderReturn.status ?? 'No status available'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _getStatusColor(orderReturn.status), // Gán màu cho status
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

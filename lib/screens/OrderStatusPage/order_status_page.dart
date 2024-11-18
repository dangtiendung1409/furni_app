import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'order_details_page.dart';
import '../../models/order.dart';
import '../../service/OrderService.dart';
import '../../service/OrderReturnService.dart';
import '../../models/orderReturn.dart';

class OrderStatusPage extends StatelessWidget {
  final int tabIndex; // Nhận chỉ mục tab từ Profile

  const OrderStatusPage({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Có 7 trạng thái đơn hàng
      initialIndex: tabIndex, // Chỉ định tab bắt đầu
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Status'),
          centerTitle: true,
          backgroundColor: kprimaryColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Confirm'),
              Tab(text: 'Shipping'),
              Tab(text: 'Shipped'),
              Tab(text: 'Complete'),
              Tab(text: 'Cancel'),
              
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            OrderList(status: 'Pending'),
            OrderList(status: 'Confirm'),
            OrderList(status: 'Shipping'),
            OrderList(status: 'Shipped'),
            OrderList(status: 'Complete'),
            OrderList(status: 'Cancel'),
            
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  final String status;

  const OrderList({super.key, required this.status});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Future<List<OrderReturn>>? _orderReturnsFuture;
  Future<List<Order>>? _ordersFuture;
  late String _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchOrders();
  }

  Future<void> _loadTokenAndFetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    if (_token.isNotEmpty) {
      setState(() {
        _ordersFuture = OrderService().fetchOrders(_token, widget.status);
      });
    } else {
      throw Exception("Token không hợp lệ.");
    }
  }
  Future<void> _updateOrderStatus(Order order) async {
    try {
      await OrderService().updateOrderStatus(
        token: _token,
        orderId: order.id,
        newStatus: 'complete',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order status updated to Complete')),
      );
      // Cập nhật lại danh sách đơn hàng
      _loadTokenAndFetchOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      // Hiển thị danh sách đơn hàng như trước đây
      return FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders.'));
          } else {
            List<Order> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_bag,
                      color: _getStatusColor(widget.status),
                    ),
                    title: Text('Order code: #${order.orderCode}'),
                    subtitle: Text(
                        'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                    trailing: widget.status == 'Shipped'
                        ? ElevatedButton(
                            onPressed: () => _updateOrderStatus(order),
                            child: const Text('Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimaryColor,
                              foregroundColor: Colors.white,
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPage(orderId: order.id.toString()),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirm':
        return Colors.blue;
      case 'Shipping':
        return Colors.purple;
      case 'Shipped':
        return Colors.lightGreen;
      case 'Complete':
        return Colors.green;
      case 'Cancel':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

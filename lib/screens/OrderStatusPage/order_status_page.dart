import 'package:flutter/material.dart';
import '../../constants.dart';
import 'order_details_page.dart';

class OrderStatusPage extends StatelessWidget {
  final int tabIndex; // Nhận chỉ mục tab từ Profile

  const OrderStatusPage({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Có 7 trạng thái đơn hàng
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
              Tab(text: 'Return'),
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
            OrderList(status: 'Return'),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final String status;

  const OrderList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> orders = _getOrdersByStatus(status);

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 3,
          child: ListTile(
            leading: Icon(
              Icons.shopping_bag,
              color: _getStatusColor(status),
            ),
            title: Text('Order ID: ${order["id"]}'),
            subtitle: Text('Status: $status'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(orderId: order["id"]!),
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<Map<String, String>> _getOrdersByStatus(String status) {
    final allOrders = [
      {"id": "001", "status": "Pending"},
      {"id": "002", "status": "Confirm"},
      {"id": "003", "status": "Shipping"},
      {"id": "004", "status": "Shipped"},
      {"id": "005", "status": "Complete"},
      {"id": "006", "status": "Cancel"},
      {"id": "007", "status": "Return"},
    ];

    return allOrders.where((order) => order["status"] == status).toList();
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
      case 'Return':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';
import '../../constants.dart';
import '../CheckOut/Widget/CartItem.dart'; // Import widget CartItem if needed

class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderDetails = _getOrderDetails(orderId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đơn hàng'),
        backgroundColor: kprimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Shipping Information (Giao hàng thành công)
            _buildShippingStatus(orderDetails),
            const SizedBox(height: 10),

            // Customer Information (Địa chỉ nhận hàng)
            _buildCustomerInfoSection(context, orderDetails),
            const SizedBox(height: 10),

            // Product Information (Danh sách sản phẩm)
            _buildProductInfoSection(context, orderDetails),
            const SizedBox(height: 10),

            // Payment Information
            _buildOrderInfoSection(orderDetails),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getOrderDetails(String orderId) {
    return {
      'products': [
        {
          'productImage': 'images/all/sweet.png',
          'productName': 'Keo Dính Chuột Siêu Dính',
          'price': '54.000',
          'quantity': '3',
        },
        {
          'productImage': 'images/all/wireless.png',
          'productName': 'Sách Giáo Khoa',
          'price': '120.000',
          'quantity': '1',
        },
        {
          'productImage': 'images/all/jacket.png',
          'productName': 'Áo Thun Trắng',
          'price': '150.000',
          'quantity': '2',
        }
      ],
      'totalAmount': '370.000',
      'orderDate': '2024-08-22',
      'paymentStatus': 'Thanh toán khi nhận hàng',
      'shippingMethod': 'SPX Express - Giao hàng thành công',
      'addressDetail': '184 Đường 19/5, Phường Văn Quán, Quận Hà Đông, Hà Nội',
      'fullName': 'ĐẶNG TIẾN DŨNG',
      'phoneNumber': '(+84) 326 921 636',
    };
  }

  // Shipping Status Section
  Widget _buildShippingStatus(Map<String, dynamic> orderDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin vận chuyển',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(orderDetails['shippingMethod']!),
        Text('22-08-2024 17:26', style: TextStyle(color: Colors.green)),
      ],
    );
  }

  // Customer Information Section
  Widget _buildCustomerInfoSection(BuildContext context, Map<String, dynamic> orderDetails) {
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
            'Địa chỉ nhận hàng',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(orderDetails['fullName']!),
          Text(orderDetails['phoneNumber']!),
          Text(orderDetails['addressDetail']!),
        ],
      ),
    );
  }

  // Product Information Section
  Widget _buildProductInfoSection(BuildContext context, Map<String, dynamic> orderDetails) {
    final products = orderDetails['products'] as List<Map<String, String>>;
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
            'Sản phẩm',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Display a list of products
          ...products.map((product) {
            return Column(
              children: [
                CartItem(
                  imageUrl: product['productImage']!,
                  productName: product['productName']!,
                  price: 'đ${product['price']}',
                  quantity: int.parse(product['quantity']!),
                ),
                const Divider(), // Optional: add a divider between products
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // Order Information Section (Total Payment, Payment Status)
  Widget _buildOrderInfoSection(Map<String, dynamic> orderDetails) {
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
            'Thành tiền: đ${orderDetails['totalAmount']}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('Phương thức thanh toán: ${orderDetails['paymentStatus']}'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CheckOut/Widget/CartItem.dart';
import '../ThankYou/thank_you_screen.dart';
import 'package:flutter_ecommerce/constants.dart';
import '../../models/cart.dart';
import '../../service/OrderService.dart';
import '../../service/CartService.dart';
import '../../service/ProductService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckOutScreen extends StatefulWidget {
  final List<Cart> cartItems;
  final double subtotal;
  const CheckOutScreen(
      {super.key, required this.cartItems, required this.subtotal});

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final OrderService _orderService = OrderService();
  DateTime? selectedDateTime;
  String? fullName;
  String? email;
  String? telephone;
  String? province;
  String? district;
  String? ward;
  String? addressDetail;
  String? shippingMethod;
  String? paymentMethod;
  String? note;

  double tax = 0.0;
  double shippingFee = 0.0;
  double total = 0.0;

  List<Map<String, String>> provinces = [];
  List<Map<String, String>> districts = [];
  List<Map<String, String>> wards = [];

  String? selectedProvinceId;
  String? selectedDistrictId;
  String? selectedWardId;

  @override
  void initState() {
    super.initState();
    _updateTotal();
    _fetchProvinces();
  }

  void _updateTotal() {
    tax = widget.subtotal * 0.1;
    total = widget.subtotal + tax + shippingFee;
    setState(() {});
  }

  Future<void> _fetchProvinces() async {
    try {
      final response =
          await http.get(Uri.parse('https://esgoo.net/api-tinhthanh/1/0.htm'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == 0) {
          setState(() {
            provinces = (data['data'] as List)
                .map((e) => {
                      'id': e['id'].toString(),
                      'name': e['full_name'].toString()
                    })
                .toList();
          });
        } else {
          print("API trả về lỗi: ${data['error_text']}");
        }
      } else {
        print("Lỗi khi tải tỉnh thành: ${response.statusCode}");
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu tỉnh: $e');
    }
  }

  Future<void> _fetchDistricts(String provinceId) async {
    try {
      final response = await http
          .get(Uri.parse('https://esgoo.net/api-tinhthanh/2/$provinceId.htm'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == 0) {
          setState(() {
            districts = (data['data'] as List)
                .map((e) => {
                      'id': e['id'].toString(),
                      'name': e['full_name'].toString()
                    })
                .toList();
            // Reset district and ward when province is changed
            selectedDistrictId = null;
            selectedWardId = null;
          });
        } else {
          print("API trả về lỗi: ${data['error_text']}");
        }
      } else {
        print("Lỗi khi tải huyện: ${response.statusCode}");
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu huyện: $e');
    }
  }

  Future<void> _fetchWards(String districtId) async {
    try {
      final response = await http
          .get(Uri.parse('https://esgoo.net/api-tinhthanh/3/$districtId.htm'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == 0) {
          setState(() {
            wards = (data['data'] as List)
                .map((e) => {
                      'id': e['id'].toString(),
                      'name': e['full_name'].toString()
                    })
                .toList();
            selectedWardId = null; // Reset ward when district is changed
          });
        } else {
          print("API trả về lỗi: ${data['error_text']}");
        }
      } else {
        print("Lỗi khi tải phường xã: ${response.statusCode}");
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu phường xã: $e');
    }
  }
Future<void> _selectDateTime(BuildContext context) async {
  DateTime currentDateTime = DateTime.now();

  // Chọn ngày
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: currentDateTime,
    firstDate: currentDateTime, // Không cho phép chọn ngày trong quá khứ
    lastDate: DateTime(2101),
  );

  if (pickedDate != null) {
    // Chọn giờ và phút
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDateTime),
    );

    if (pickedTime != null) {
      // Kết hợp ngày và giờ đã chọn
      final DateTime selected = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Kiểm tra nếu thời gian đã chọn không ở trong quá khứ
      if (selected.isBefore(currentDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selected time is in the past. Please choose a future time.")),
        );
        return; // Không cập nhật nếu thời gian đã qua
      }

      // Cập nhật nếu thời gian hợp lệ
      setState(() {
        selectedDateTime = selected;
      });
    }
  }
}



  Future<void> _submitOrder() async {
    final orderDetails = {
      "full_name": fullName,
      "email": email,
      "telephone": telephone,
      "province": province,
      "district": district,
      "ward": ward,
      "address_detail": addressDetail,
      "shipping_method": shippingMethod,
      "payment_method": paymentMethod,
      "note": note ?? "",
      "schedule": selectedDateTime?.toIso8601String(),
      "total": total,
    };

    final products = widget.cartItems.map((cartItem) {
      return {
        "product_id": cartItem.product.id,
        "qty": cartItem.qty,
      };
    }).toList();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token not found")),
      );
      return;
    }

    try {
      final newOrder = await _orderService.createOrder(
        token: token,
        orderDetails: orderDetails,
        products: products,
      );
      final productService = ProductService();
      for (var cartItem in widget.cartItems) {
        if (cartItem.product.id != null) {
          await productService.updateProductQuantity(
            token,
            cartItem.product.id!,
            cartItem.qty,
          );
        } else {
          // Handle the case where product.id is null (e.g., show an error message)
          print("Product ID is null for ${cartItem.product.productName}");
        }
      }

      // Xóa toàn bộ giỏ hàng trên server
      final cartService = CartService();
      await cartService.clearCart(token);

      // Xóa giỏ hàng trong ứng dụng
      await prefs.remove('cartItems');
      setState(() {
        widget.cartItems.clear();
      });

      // Điều hướng tới màn hình Thank You
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ThankYouScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create order: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
        backgroundColor: kprimaryColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWithLabel(
                label: 'Full Name', onChanged: (value) => fullName = value),
            const SizedBox(height: 10),
            TextFieldWithLabel(
                label: 'Email', onChanged: (value) => email = value),
            const SizedBox(height: 10),
            TextFieldWithLabel(
                label: 'Telephone', onChanged: (value) => telephone = value),
            const SizedBox(height: 10),
            // Dropdown for Province
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Province', // Label cho Province
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedProvinceId,
                    items: provinces
                        .map((province) => DropdownMenuItem(
                              value: province['id'],
                              child: Text(province['name']!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvinceId = value;
                        province = provinces
                            .firstWhere((p) => p['id'] == value)['name'];
                        if (selectedProvinceId != null) {
                          _fetchDistricts(selectedProvinceId!);
                        }
                      });
                    },
                    hint: const Text('Select Province'), // Text mặc định nếu chưa chọn
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dropdown for District
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'District', // Label cho District
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDistrictId,
                    items: districts
                        .map((district) => DropdownMenuItem(
                              value: district['id'],
                              child: Text(district['name']!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrictId = value;
                        district = districts
                            .firstWhere((d) => d['id'] == value)['name'];
                        if (selectedDistrictId != null) {
                          _fetchWards(selectedDistrictId!);
                        }
                      });
                    },
                    hint: const Text('Select District'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dropdown for Ward
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ward', // Label cho Ward
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedWardId,
                    items: wards
                        .map((ward) => DropdownMenuItem(
                              value: ward['id'],
                              child: Text(ward['name']!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedWardId = value;
                        ward = wards.firstWhere((w) => w['id'] == value)['name'];
                      });
                    },
                    hint: const Text('Select Ward'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFieldWithLabel(
                label: 'Address Detail',
                onChanged: (value) => addressDetail = value),
            const SizedBox(height: 20),
            const Text(
              'Shipping Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(
                    value: 'J&T Express', child: Text('J&T Express')),
                DropdownMenuItem(value: 'Ninja Van', child: Text('Ninja Van')),
              ],
              onChanged: (value) {
                setState(() {
                  shippingMethod = value;
                  shippingFee = value == 'J&T Express'
                      ? 20.0
                      : 15.0; // Phí vận chuyển ví dụ
                  _updateTotal(); // Tính lại total
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
              hint: const Text('Select a shipping method'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'COD', child: Text('COD')),
                DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
              ],
              onChanged: (value) => setState(() => paymentMethod = value),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
              hint: const Text('Select a payment method'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Delivery Date & Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDateTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                child: Text(
                  selectedDateTime == null
                      ? 'Select a date & time'
                      : '${selectedDateTime!.toLocal()}'.split(' ')[0] +
                          ' ' +
                          '${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color:
                        selectedDateTime == null ? Colors.grey : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFieldWithLabel(
              label: 'Note (Optional)',
              onChanged: (value) {
                note = value.isEmpty ? null : value;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Cart Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            for (var cartItem in widget.cartItems)
              CartItem(
                imageUrl: cartItem.product.thumbnail != null
                    ? base64Decode(cartItem.product.thumbnail!)
                    : 'assets/default_image.png',
                productName: cartItem.product.productName ?? 'No Name',
                price: '\$${cartItem.product.price}',
                quantity: cartItem.qty,
              ),
            const SizedBox(height: 20),
            const Text(
              'Cart Total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cartTotalRow(
                      'Subtotal', '\$${widget.subtotal.toStringAsFixed(2)}'),
                  _cartTotalRow('Tax (10%)', '\$${tax.toStringAsFixed(2)}'),
                  _cartTotalRow(
                      'Shipping Fee', '\$${shippingFee.toStringAsFixed(2)}'),
                  _cartTotalRow('Total', '\$${total.toStringAsFixed(2)}',
                      isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: _submitOrder,
              child: const Text(
                'Confirm Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartTotalRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const TextFieldWithLabel(
      {super.key, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../CheckOut/Widget/CartItem.dart';
import '../ThankYou/thank_you_screen.dart';
import 'package:flutter_ecommerce/constants.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  DateTime? selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
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
        ), // Màu AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextFieldWithLabel(label: 'Full Name'),
            const SizedBox(height: 10),
            const TextFieldWithLabel(label: 'Email'),
            const SizedBox(height: 10),
            const TextFieldWithLabel(label: 'Telephone'),
            const SizedBox(height: 10),
            const TextFieldWithLabel(label: 'Province'),
            const SizedBox(height: 10),
            const TextFieldWithLabel(label: 'District'),
            const SizedBox(height: 10),
            const TextFieldWithLabel(label: 'Ward'),
            const SizedBox(height: 10),
            const TextFieldWithLabel(label: 'Address Detail'),
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
                    value: 'standard', child: Text('Standard Shipping')),
                DropdownMenuItem(
                    value: 'express', child: Text('Express Shipping')),
              ],
              onChanged: (value) {},
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

            const TextFieldWithLabel(label: 'Note (Optional)'),
            const SizedBox(height: 20),

            // Section for Cart Items
            const Text(
              'Cart Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            CartItem(
              imageUrl: 'images/all/sweet.png',
              productName: 'Sapphire Splendor Pendant',
              price: '\$853.0',
              quantity: 1,
            ),
            CartItem(
              imageUrl:
                  'images/all/wireless.png', // Thay thế bằng hình ảnh của sản phẩm thứ hai
              productName: 'Elegant Gold Bracelet',
              price: '\$245.0',
              quantity: 2,
            ),
            CartItem(
              imageUrl:
                  'images/all/miband.jpg', // Thay thế bằng hình ảnh của sản phẩm thứ ba
              productName: 'Classic Diamond Ring',
              price: '\$1,299.0',
              quantity: 5,
            ),

            const SizedBox(height: 20),

            // Section for Cart Total
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
                  _cartTotalRow('Subtotal', '', '\$853.0'),
                  _cartTotalRow('Tax(10%)', '', '\$85.30'),
                  _cartTotalRow('Shipping Fee', '', '\$0.00'),
                  _cartTotalRow('Total', '', '\$938.30', isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor, // Màu của nút
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                // Chuyển đến ThankYouScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThankYouScreen()),
                );
              },
              child: const Text(
                'Confirm Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cartTotalRow(String title, String? product, String amount,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Widget tái sử dụng cho các trường nhập liệu
class TextFieldWithLabel extends StatelessWidget {
  final String label;

  const TextFieldWithLabel({required this.label});

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
        const SizedBox(height: 5),
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
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../service/OrderService.dart';
import '../Profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../OrderStatusPage/order_status_page.dart';

class CancelOrderReasonPage extends StatefulWidget {
  final String orderId;

  const CancelOrderReasonPage({super.key, required this.orderId});

  @override
  _CancelOrderReasonPageState createState() => _CancelOrderReasonPageState();
}

class _CancelOrderReasonPageState extends State<CancelOrderReasonPage> {
  String? selectedReason;
  TextEditingController otherReasonController = TextEditingController();
  late String _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<void> cancelOrder(String reason) async {
    try {
      int orderId = int.parse(widget.orderId);
      await OrderService().updateOrderStatus(
        token: _token,
        orderId: orderId,
        newStatus: 'cancel',
        cancelReason: reason,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order status updated successfully")),
      );
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const OrderStatusPage(tabIndex: 5), // Tab "Cancel"
  ),
);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel order: $e")),
      );
    }
  }

  void _submitCancelOrder() {
    String reason = selectedReason == "Other"
        ? otherReasonController.text
        : selectedReason ?? "No reason provided";
    cancelOrder(reason);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancel Order"),
        backgroundColor: kprimaryColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Do you want to cancel your order? Please tell us why",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RadioListTile<String>(
              contentPadding: EdgeInsets.symmetric(horizontal: -10.0),
              title: Text("Order takes a long time to confirm"),
              value: "Order takes a long time to confirm",
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.symmetric(horizontal: -10.0),
              title: Text("I don't need to buy anymore"),
              value: "I don't need to buy anymore",
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.symmetric(horizontal: -10.0),
              title: Text("I want to update my shipping address"),
              value: "I want to update my shipping address",
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.symmetric(horizontal: -10.0),
              title: Text("I found a better place to buy"),
              value: "I found a better place to buy",
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.symmetric(horizontal: -10.0),
              title: Text("I don't have enough money to buy it"),
              value: "I don't have enough money to buy it",
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.symmetric(horizontal: -10.0),
              title: Text("Other"),
              value: "Other",
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() => selectedReason = value);
              },
            ),
            if (selectedReason == "Other")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: otherReasonController,
                  minLines: 3, // Minimum number of lines
                  maxLines: 5, // Maximum number of lines
                  decoration: InputDecoration(
                    labelText: "Please specify your reason",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kprimaryColor, width: 2.0),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
              ),
              onPressed: _submitCancelOrder,
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

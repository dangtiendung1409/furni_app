import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../service/OrderReturnService.dart';

class ReturnOrderPage extends StatefulWidget {
  final int orderId;
  final int productId;
  final double refundAmount;
  final int qty;

  const ReturnOrderPage({
    super.key,
    required this.orderId,
    required this.productId,
    required this.refundAmount,
    required this.qty,
  });

  @override
  _ReturnOrderPageState createState() => _ReturnOrderPageState();
}

class _ReturnOrderPageState extends State<ReturnOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedReason;
  String? _description;
  List<File> _images = [];
  final List<String> _returnReasons = [
    'Missing quantity/accessories',
    'Seller sent wrong item',
    'The product cannot be used',
    'Different from description',
    'Counterfeit goods',
    'Imitation goods',
    'The goods are intact but no longer needed',
  ];

  // Chọn ảnh từ thư viện
  Future<void> _pickImages() async {
    if (_images.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only select up to 4 images')),
      );
      return;
    }

    final ImagePicker _picker = ImagePicker();
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        if (_images.length + pickedFiles.length <= 4) {
          _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only select up to 4 images')),
          );
        }
      });
    }
  }

  // Gửi yêu cầu hoàn trả
  void _submitReturnRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Lấy token từ SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';

        if (token.isEmpty) {
          throw Exception('Token is missing. Please log in again.');
        }

        // Chuyển đổi ảnh sang base64
        List<String> encodedImages = [];
        for (File image in _images) {
          final bytes = await image.readAsBytes();
          encodedImages.add(base64Encode(bytes));
        }

        // Gửi yêu cầu API
        final orderReturnService = OrderReturnService();
        await orderReturnService.createOrderReturn(
          token,
          widget.orderId,
          widget.productId,
          widget.qty, // Sử dụng qty truyền từ widget mà không hiện lên giao diện
          _selectedReason!,
          widget.refundAmount,
          _description!,
          encodedImages,
        );

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Return request submitted successfully!')),
        );

        // Điều hướng về trang trước
        Navigator.pop(context);
      } catch (error) {
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit return request: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Product'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Chọn lý do hoàn trả
              DropdownButtonFormField<String>(
                value: _selectedReason,
                onChanged: (newValue) {
                  setState(() {
                    _selectedReason = newValue;
                  });
                },
                items: _returnReasons.map((reason) {
                  return DropdownMenuItem<String>(
                    value: reason,
                    child: Text(
                      reason,
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Reason for return',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a reason';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mô tả chi tiết
              TextFormField(
                onChanged: (value) {
                  _description = value;
                },
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Chọn ảnh
              const Text('Select Images (up to 4):'),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _images.length + (_images.length < 4 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _images.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        Image.file(
                          _images[index],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Hiển thị số tiền hoàn trả
              TextFormField(
                initialValue: widget.refundAmount.toStringAsFixed(2),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Refund Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Nút gửi yêu cầu
              ElevatedButton(
                onPressed: _submitReturnRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Return Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

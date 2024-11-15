import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/ReviewService.dart';
import '../../constants.dart';

class FormReviewScreen extends StatefulWidget {
  final int productId;

  const FormReviewScreen({super.key, required this.productId});

  @override
  _FormReviewScreenState createState() => _FormReviewScreenState();
}

class _FormReviewScreenState extends State<FormReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  int _ratingValue = 1; // Số sao mặc định là 1

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Hàm để gửi đánh giá
  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      // Lấy thông tin người dùng từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        // Nếu không có token, thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
        return;
      }

      try {
        // Gửi yêu cầu đăng đánh giá
        await ReviewService().postReview(
          token,
          widget.productId,
          _ratingValue,
          _commentController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review posted successfully')),
        );
        Navigator.pop(context); // Quay lại trang trước đó sau khi đăng đánh giá
      } catch (e) {
        print("Error details: $e"); // In chi tiết lỗi ra
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post review bro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Review'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rating (1 to 5)',
                style: TextStyle(fontSize: 16),
              ),
              // Các ngôi sao có thể bấm
              Row(
                children: List.generate(5, (index) {
                  int rating = index + 1;
                  return IconButton(
                    icon: Icon(
                      rating <= _ratingValue
                          ? Icons.star
                          : Icons
                              .star_border, // Hiển thị sao đã chọn hoặc chưa chọn
                      color: rating <= _ratingValue
                          ? Colors.orange // Màu vàng cho sao đã chọn
                          : Colors.grey, // Màu xám cho sao chưa chọn
                    ),
                    onPressed: () {
                      setState(() {
                        _ratingValue =
                            rating; // Cập nhật số sao khi người dùng bấm
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor, // Màu nền của nút
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

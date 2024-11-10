import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/models/product.dart';
import '../../../service/CartService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCart extends StatefulWidget {
  final Product product;
  const AddToCart({super.key, required this.product});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int currentIndex = 1;
  final CartService cartService = CartService();

  Future<void> _handleAddToCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception("User is not logged in");
      }

      // Kiểm tra số lượng sản phẩm có đủ hay không
      int availableQty = await cartService.checkProductQty(widget.product.id!);
      if (currentIndex > availableQty) {
        // Nếu số lượng yêu cầu lớn hơn số lượng có sẵn, thông báo cho người dùng
        const snackBar = SnackBar(
          content: Text(
            "This product is out of stock. The remaining quantity is not enough.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;  // Dừng quá trình thêm vào giỏ hàng
      }

      // Tính tổng giá trị sản phẩm
      double total = (widget.product.price ?? 0) * currentIndex;

      // Thêm sản phẩm vào giỏ hàng
      final cartResponse = await cartService.addToCart(widget.product.id!, currentIndex, token);

      // Hiển thị thông báo thành công
      const snackBar = SnackBar(
        content: Text(
          "Added to cart successfully!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } catch (e) {
      // Tránh báo lỗi chung, chỉ thông báo cho người dùng về việc hết hàng nếu cần
      if (e.toString().contains("This product is out of stock")) {
        const snackBar = SnackBar(
          content: Text(
            "This product is out of stock. The remaining quantity is not enough.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentIndex != 1) {
                        setState(() {
                          currentIndex--;
                        });
                      }
                    },
                    iconSize: 18,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentIndex.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex++;
                      });
                    },
                    iconSize: 18,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: _handleAddToCart,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../Provider/favorite_provider.dart';
import '../../Cart/cart_screen.dart';

class DetailAppBar extends StatelessWidget {
  final Product product;
  const DetailAppBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 10),
          Consumer<FavoriteProvider>( // Dùng Consumer để cập nhật UI khi trạng thái thay đổi
            builder: (context, provider, child) {
              return IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');
                  if (token != null) {
                    // Khi người dùng thêm hoặc xóa yêu thích, cập nhật trạng thái ngay lập tức
                    await provider.toggleFavorite(product, token);

                    // Hiển thị thông báo thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.isExist(product)
                              ? 'Successfully added to favorites'
                              : 'Successfully removed from favorites',
                        ),
                      ),
                    );
                  } else {
                    // Hiển thị thông báo nếu chưa đăng nhập
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login to add to favorites.')),
                    );
                  }
                },
                icon: Icon(
                  provider.isExist(product) ? Icons.favorite : Icons.favorite_border,
                  color: provider.isExist(product) ? Colors.red : Colors.black, // Đổi màu tim khi có yêu thích
                  size: 25,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

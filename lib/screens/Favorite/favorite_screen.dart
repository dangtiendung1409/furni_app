import 'dart:convert'; // Thêm import này để sử dụng base64
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ecommerce/Provider/favorite_provider.dart';
import '../../constants.dart';
import '../Cart/cart_screen.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await provider.fetchFavorites(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final finalList = provider.favorites;

    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        title: const Text(
          "Favorite",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: finalList.isEmpty
          ? Center(child: Text('No favorites found'))
          : ListView.builder(
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                final favoriteItem = finalList[index];
                final product = favoriteItem.product;

                return Dismissible(
                  key: Key(favoriteItem.productId.toString()),
                  direction: DismissDirection
                      .endToStart, // Kéo từ phải qua trái để xóa
                  onDismissed: (direction) async {
                    // Xóa sản phẩm khi bị kéo
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');
                    if (token != null) {
                      await provider.toggleFavorite(
                          product!, token); // Gọi phương thức xóa
                      // Hiển thị thông báo thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product removed from favorites'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red, // Màu nền khi kéo để xóa
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: 90,
                            height: 100,
                            child: product?.thumbnail != null
                                ? Image.memory(
                                    base64Decode(product!
                                        .thumbnail!), // Giải mã chuỗi Base64
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox
                                    .shrink(), // Hiển thị nếu không có hình
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product?.productName ?? 'Unknown Product',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product?.category?.categoryName ??
                                      'Unknown Category',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "\$${product?.price ?? 0}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final token = prefs.getString('token');
                              if (token != null) {
                                await provider.toggleFavorite(
                                    product!, token); // Gọi phương thức xóa
                                // Hiển thị thông báo thành công
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Product removed from favorites'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

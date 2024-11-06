import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:flutter_ecommerce/Provider/add_to_cart_provider.dart';
import 'package:flutter_ecommerce/screens/Cart/check_out.dart';
import '../../constants.dart';
import '../../service/CartService.dart';
import 'package:flutter_ecommerce/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Cart>> _cartItems;
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  double getSubtotal(List<Cart> cartItems) {
    double subtotal = 0.0;
    for (var cartItem in cartItems) {
      subtotal += cartItem.totalPrice;
    }
    return subtotal;
  }

  Future<void> _removeFromCart(int productId) async {
    try {
      await CartService().removeFromCart(productId, token);
      setState(() {
        _cartItems = CartService().fetchCart(token);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sản phẩm đã được xóa khỏi giỏ hàng")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  Future<void> _updateCart(int productId, int qty) async {
    try {
      await CartService().updateCart(productId, qty, token);
      setState(() {
        _cartItems = CartService().fetchCart(token);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Số lượng sản phẩm đã được cập nhật")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (token.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text("Please login to view your cart."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kcontentColor,
      bottomSheet: FutureBuilder<List<Cart>>(
        future: CartService().fetchCart(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in cart'));
          }

          List<Cart> cartItems = snapshot.data!;
          double subtotal = getSubtotal(cartItems);

          return CheckOutBox(subtotal: subtotal);
        },
      ),
      body: SafeArea(
        child: FutureBuilder<List<Cart>>(
          future: CartService().fetchCart(token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No items in cart'));
            }

            List<Cart> cartItems = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 230), // Khoảng cách cách bottom
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  Cart cartItem = cartItems[index];
                  Product product = cartItem.product;

                  return Dismissible(
                    key: Key(cartItem.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Xóa sản phẩm"),
                          content: const Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Không"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Có"),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      _removeFromCart(cartItem.product.id!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 90,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: kcontentColor,
                              ),
                              child: product.thumbnail != null && product.thumbnail!.isNotEmpty
                                  ? Image.memory(base64Decode(product.thumbnail!), fit: BoxFit.cover)
                                  : const Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.productName ?? 'No Name',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _removeFromCart(product.id!);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.category?.categoryName ?? 'Unknown Category',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.grey.shade400),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade400),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              iconSize: 15,
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                if (cartItem.qty! > 1) {
                                                  _updateCart(cartItem.product.id!, cartItem.qty! - 1);
                                                }
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Text(
                                                cartItem.qty.toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              iconSize: 15,
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                _updateCart(cartItem.product.id!, cartItem.qty! + 1);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "\$${product.price}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

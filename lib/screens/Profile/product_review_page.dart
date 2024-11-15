import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../Profile/form_review_screen.dart';
import '../../service/ReviewService.dart';
import '../../models/product.dart';
import '../../models/orderProduct.dart';
import '../../models/review.dart';

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({super.key});

  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  late Future<List<OrderProduct>> _reviewableProductsFuture;
  late Future<List<Review>> _approvedReviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewableProductsFuture = _fetchReviewableProducts();
    _approvedReviewsFuture = _fetchApprovedReviews();
  }

  // Fetch products that need reviews
  Future<List<OrderProduct>> _fetchReviewableProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return await ReviewService().fetchReviewableProducts(token);
  }

  // Fetch approved reviews
  Future<List<Review>> _fetchApprovedReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return await ReviewService().fetchApprovedReviews(token);
  }

  // Helper function to display star rating
  Widget _buildRatingStars(int ratingValue) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= ratingValue ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18.0,
        ),
      );
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Reviews'),
          backgroundColor: kprimaryColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            tabs: [
              Tab(text: 'To Review'),
              Tab(text: 'Reviewed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: List of products to review
            FutureBuilder<List<OrderProduct>>(
              future: _reviewableProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load products'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products to review'));
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index].product!;
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: product.thumbnail != null
                              ? Image.memory(
                                  base64Decode(product.thumbnail!),
                                  width: 70,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image),
                          title: Text('${product.productName ?? 'Unknown Product'}'),
                          subtitle: Text('\$${product.price?.toStringAsFixed(2) ?? 'N/A'}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.rate_review),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormReviewScreen(
                                    productId: products[index].productId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            // Tab 2: Approved reviews
            FutureBuilder<List<Review>>(
              future: _approvedReviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load reviews'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reviews to show'));
                } else {
                  final reviews = snapshot.data!;
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: review.product?.thumbnail != null
                              ? Image.memory(
                                  base64Decode(review.product!.thumbnail!),
                                  width: 90,
                                  height: 170,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image),
                          title: Text(review.product?.productName ?? 'Unknown Product'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRatingStars(review.ratingValue ?? 0),
                              Text('Price: \$${review.product?.price?.toStringAsFixed(2) ?? 'N/A'}'),
                              Text('Date: ${review.getFormattedDate()}'),
                              Text('Comment: ${review.comment ?? ''}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

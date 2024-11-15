import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/addto_cart.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/detail_app_bar.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/items_details.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/custom_tab_bar.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/related_products.dart';
import '../../service/ReviewService.dart';
import '../../service/ProductService.dart';
import '../../models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late List<Product> relatedProducts = [];
  late List<Review> reviews = [];
  late TabController _tabController;
  int _selectedTabIndex = 0;
  double averageRating = 0.0; 
  int totalReviews = 0;
  final ProductService productService = ProductService();
  final ReviewService reviewService = ReviewService();

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
    _fetchReviews();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _fetchRelatedProducts() async {
    try {
      relatedProducts =
          await productService.fetchRelatedProducts(widget.product.id!);
      setState(() {}); // Cập nhật giao diện khi dữ liệu được tải
    } catch (e) {
      print(e);
    }
  }
Future<void> _fetchReviews() async {
    try {
      // Lấy token từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // Gọi API để lấy danh sách review
        reviews = await reviewService.fetchReviewsByProductId(token, widget.product.id!);

        // Tính tổng số lượng review
        totalReviews = reviews.length;

        // Tính số sao trung bình
        if (totalReviews > 0) {
          double totalRating = reviews.fold(
              0.0, (sum, review) => sum + (review.ratingValue ?? 0));
          averageRating = totalRating / totalReviews;
        } else {
          averageRating = 0.0; // Không có review
        }

        setState(() {}); // Cập nhật giao diện sau khi tính toán
      } else {
        print("No token found");
      }
    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }
  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _tabController.index = index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      floatingActionButton: AddToCart(product: widget.product),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailAppBar(product: widget.product),
              const SizedBox(height: 10),
              if (widget.product.thumbnail != null)
                Image.memory(
                  base64Decode(widget.product.thumbnail!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                const Center(child: Text("No Image Available")),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemsDetails(
                      product: widget.product,
                      averageRating: averageRating,
                      totalReviews: totalReviews,
                    ),
                    const SizedBox(height: 20),
                    CustomTabBarView(
                      tabController: _tabController,
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: _onTabTapped,
                      product: widget.product,
                      reviews: reviews,
                    ),
                    const SizedBox(height: 20),
                    RelatedProducts(relatedProducts: relatedProducts),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

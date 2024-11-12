import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/addto_cart.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/detail_app_bar.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/items_details.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/custom_tab_bar.dart';
import 'package:flutter_ecommerce/screens/Detail/Widget/related_products.dart';
import '../../service/ProductService.dart';
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
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
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
                    ItemsDetails(product: widget.product),
                    const SizedBox(height: 20),
                    CustomTabBarView(
                      tabController: _tabController,
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: _onTabTapped,
                      product: widget.product,
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

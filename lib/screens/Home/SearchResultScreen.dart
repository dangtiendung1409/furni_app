import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../service/ProductService.dart';
import 'Widget/product_cart.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<Product> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSearchResults();
  }

  Future<void> fetchSearchResults() async {
    try {
      ProductService productService = ProductService();
      searchResults = await productService.fetchProductsByName(widget.searchQuery);
    } catch (e) {
      print('Error fetching search results: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Found ${searchResults.length} results for "${widget.searchQuery}"',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: searchResults.isEmpty
                        ? Center(child: Text('No products found for "${widget.searchQuery}"'))
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: searchResults[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'dart:convert';
import '../detail_screen.dart';

class RelatedProducts extends StatelessWidget {
  final List<Product> relatedProducts;

  const RelatedProducts({Key? key, required this.relatedProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Related Products",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length > 5
                ? 5
                : relatedProducts.length,
            itemBuilder: (context, index) {
              final relatedProduct = relatedProducts[index];
              return GestureDetector(
                onTap: () {
                  // Điều hướng đến chi tiết sản phẩm
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(product: relatedProduct),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      if (relatedProduct.thumbnail != null)
                        Image.memory(
                          base64Decode(relatedProduct.thumbnail!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          relatedProduct.productName ?? 'N/A',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Hiển thị giá sản phẩm
                      Text(
                        '\$${relatedProduct.price?.toStringAsFixed(2) ?? 'N/A'}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

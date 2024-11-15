import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemsDetails extends StatelessWidget {
  final Product product;
  final double averageRating; // Số sao trung bình
  final int totalReviews;
  const ItemsDetails({
    super.key,
    required this.product,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName ?? "No Name",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$${product.price?.toStringAsFixed(2) ?? "0.00"}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Category: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: product.category?.categoryName ?? "Unknown",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Hiển thị số sao và số lượng review với dữ liệu cứng
        Row(
          children: [
            RatingBarIndicator(
              rating: averageRating, // Số sao trung bình
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5, // Tổng số sao
              itemSize: 20.0, // Kích thước mỗi sao
              direction: Axis.horizontal,
            ),
            const SizedBox(width: 10),
            Text(
              "($totalReviews Reviews)", // Tổng số review
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Mô tả sản phẩm
        // Text(
        //   "Description: ${product.description ?? "No description available."}",
        //   style: const TextStyle(
        //     fontSize: 14,
        //   ),
        // ),
      ],
    );
  }
}

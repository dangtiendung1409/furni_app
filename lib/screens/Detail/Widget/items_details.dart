import 'package:flutter_ecommerce/constants.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/category.dart';
import 'package:flutter/material.dart';

class ItemsDetails extends StatelessWidget {
  final Product product;
  const ItemsDetails({super.key, required this.product});

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
            Container(
              width: 55,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kprimaryColor,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "4.5", // Số sao cố định
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "(320 Reviews)", // Số lượng review cố định
              style: TextStyle(
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
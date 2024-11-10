import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final dynamic imageUrl; // Có thể là String hoặc Uint8List
  final String productName;
  final String price;
  final int quantity;

  const CartItem({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        imageUrl is String
            ? Image.asset(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : Image.memory(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Quantity: $quantity',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

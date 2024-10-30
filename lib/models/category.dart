import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Category {
  final int id;
  final String categoryName;
  final String image; // Giả sử đây là chuỗi Base64
  final String? slug;

  Category({
    required this.id,
    required this.categoryName,
    required this.image,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      image: json['image'] ?? '', // Đây sẽ là chuỗi Base64
      slug: json['slug'],
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Category sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'image': image,
      'slug': slug,
    };
  }

  // Phương thức để chuyển đổi hình ảnh Base64 thành Uint8List
  Uint8List getImageFromBase64() {
    return base64Decode(image);
  }
}

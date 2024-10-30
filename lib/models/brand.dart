import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Brand {
  final int id;
  final String brandName;

  Brand({required this.id, required this.brandName});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? 0,
      brandName: json['brand_name'] ?? '',
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Brand sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_name': brandName,
    };
  }
}

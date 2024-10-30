import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Size {
  final int id;
  final String sizeName;

  Size({required this.id, required this.sizeName});

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      id: json['id'] ?? 0,
      sizeName: json['size_name'] ?? '',
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Size sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size_name': sizeName,
    };
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Material {
  final int id;
  final String materialName;

  Material({required this.id, required this.materialName});

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'] ?? 0,
      materialName: json['material_name'] ?? '',
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Material sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'material_name': materialName,
    };
  }
}

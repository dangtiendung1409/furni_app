import 'dart:convert';
import 'brand.dart';
import 'category.dart';
import 'size.dart';
import 'material.dart';

class Product {
  int? id;
  String? productName; // Tương ứng với product_name
  String? slug; // Tương ứng với slug
  double? price; // Tương ứng với price
  String? thumbnail; // Tương ứng với thumbnail
  int? qty; // Tương ứng với qty
  Category? category; // Tương ứng với category
  Brand? brand; // Tương ứng với brand
  Material? material; // Tương ứng với material
  Size? size; // Tương ứng với size
  String? color; // Tương ứng với color
  double? weight; // Tương ứng với weight
  double? height; // Tương ứng với height
  double? length; // Tương ứng với length

  // Constructor
  Product({
    this.id,
    this.productName,
    this.slug,
    this.price,
    this.thumbnail,
    this.qty,
    this.category,
    this.brand,
    this.material,
    this.size,
    this.color,
    this.weight,
    this.height,
    this.length,
  });

  // Phương thức để chuyển đổi từ JSON sang đối tượng Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      slug: json['slug'],
      price: json['price']?.toDouble(),
      thumbnail: json['thumbnail'],
      qty: json['qty'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      material: json['material'] != null ? Material.fromJson(json['material']) : null,
      size: json['size'] != null ? Size.fromJson(json['size']) : null,
      color: json['color'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      length: json['length']?.toDouble(),
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Product sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'slug': slug,
      'price': price,
      'thumbnail': thumbnail,
      'qty': qty,
      'category': category?.toJson(),
      'brand': brand?.toJson(),
      'material': material?.toJson(),
      'size': size?.toJson(),
      'color': color,
      'weight': weight,
      'height': height,
      'length': length,
    };
  }
}

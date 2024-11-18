import 'dart:convert';

class ReturnImage {
  final int id;
  final String imagePath; 
  final int orderReturnId; 

  ReturnImage({
    required this.id,
    required this.imagePath,
    required this.orderReturnId,
  });

  factory ReturnImage.fromJson(Map<String, dynamic> json) {
    return ReturnImage(
      id: json['id'] ?? 0,
      imagePath: json['image_path'] ?? '',
      orderReturnId: json['order_return_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'order_return_id': orderReturnId,
    };
  }
}

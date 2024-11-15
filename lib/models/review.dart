import 'dart:convert';
import 'package:intl/intl.dart';
import 'product.dart';
import 'user.dart';

class Review {
  int? id;
  String? comment;
  String? status;
  DateTime? reviewDate;
  int? ratingValue;
  int? productId; 
  int? userId; 
  Product? product; 
  User? user; 

  // Constructor
  Review({
    this.id,
    this.comment,
    this.status,
    this.reviewDate,
    this.ratingValue,
    this.productId,
    this.userId,
    this.product, 
    this.user, 
  });

  // Phương thức để chuyển đổi từ JSON sang đối tượng Review
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      comment: json['comment'],
      status: json['status'],
      reviewDate: json['review_date'] != null
          ? DateTime.parse(json['review_date'])
          : null,
      ratingValue: json['rating_value'],
      productId: json['product_id'],
      userId: json['user_id'],
      product: json['product'] != null
          ? Product.fromJson(json['product']) 
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user']) 
          : null,
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Review sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'status': status,
      'review_date': reviewDate?.toIso8601String(),
      'rating_value': ratingValue,
      'product_id': productId,
      'user_id': userId,
      'product': product?.toJson(), 
      'user': user?.toJson(), 
    };
  }

  // Format ngày tháng năm
  String getFormattedDate() {
    if (reviewDate != null) {
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(reviewDate!);
    }
    return '';
  }
}

import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'product.dart';
import 'user.dart';

class Review {
  int? id;
  Product? product;
  User? user;
  String? comment;
  String? status;
  DateTime? reviewDate;
  int? ratingValue;

  // Constructor
  Review({
    this.id,
    this.product,
    this.user,
    this.comment,
    this.status,
    this.reviewDate,
    this.ratingValue,
  });

  // Phương thức để chuyển đổi từ JSON sang đối tượng Review
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      comment: json['comment'],
      status: json['status'],
      reviewDate: json['review_date'] != null
          ? DateTime.parse(json['review_date'])
          : null,
      ratingValue: json['rating_value'],
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Review sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'user': user?.toJson(),
      'comment': comment,
      'status': status,
      'review_date': reviewDate?.toIso8601String(), // Format date as ISO 8601 string
      'rating_value': ratingValue,
    };
  }

  // Optional: A helper function to format reviewDate for display purposes
  String getFormattedReviewDate() {
    if (reviewDate == null) return '';
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(reviewDate!);
  }
}

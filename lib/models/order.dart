import 'dart:convert';

class Order {
  final int id;
  final int userId;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final String isPaid;
  final String province;
  final String district;
  final String ward;
  final String addressDetail;
  final String fullName;
  final String email;
  final String telephone;
  final String paymentMethod;
  final String shippingMethod;
  final String? note;
  final DateTime? schedule;
  final String? cancelReason;
  final String orderCode;
  final String secureToken;

  Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.isPaid,
    required this.province,
    required this.district,
    required this.ward,
    required this.addressDetail,
    required this.fullName,
    required this.email,
    required this.telephone,
    required this.paymentMethod,
    required this.shippingMethod,
    this.note,
    this.schedule,
    this.cancelReason,
    required this.orderCode,
    required this.secureToken,
  });

  // Phương thức từ JSON sang đối tượng Order
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderDate: DateTime.parse(json['order_date']),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] ?? '',
      isPaid: json['is_paid'] ?? '',
      province: json['province'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      addressDetail: json['address_detail'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      shippingMethod: json['shipping_method'] ?? '',
      note: json['note'],
      schedule: json['schedule'] != null ? DateTime.parse(json['schedule']) : null,
      cancelReason: json['cancel_reason'],
      orderCode: json['order_code'] ?? '',
      secureToken: json['secure_token'] ?? '',
    );
  }

  // Phương thức từ đối tượng Order sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'status': status,
      'is_paid': isPaid,
      'province': province,
      'district': district,
      'ward': ward,
      'address_detail': addressDetail,
      'full_name': fullName,
      'email': email,
      'telephone': telephone,
      'payment_method': paymentMethod,
      'shipping_method': shippingMethod,
      'note': note,
      'schedule': schedule?.toIso8601String(),
      'cancel_reason': cancelReason,
      'order_code': orderCode,
      'secure_token': secureToken,
    };
  }
}

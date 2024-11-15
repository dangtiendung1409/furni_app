import 'product.dart';
class OrderProduct {
  final int orderId;
  final int productId;
  final double price;
  final int qty;
  final int status;
  final Product product; 

  OrderProduct({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.qty,
    required this.status,
    required this.product, 
  });

factory OrderProduct.fromJson(Map<String, dynamic> json) {
  return OrderProduct(
    orderId: json['orderId'] ?? 0,  // Sử dụng 'orderId' thay vì 'order_id'
    productId: json['productId'] ?? 0,  // Sử dụng 'productId' thay vì 'product_id'
    price: (json['price'] as num).toDouble(),
    qty: json['qty'] ?? 0,
    status: json['status'] ?? 0,
    product: Product.fromJson(json['product']), 
  );
}


  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'price': price,
      'qty': qty,
      'status': status,
      'product': product.toJson(),
    };
  }
}

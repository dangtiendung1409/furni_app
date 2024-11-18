import './user.dart';
import './product.dart';
import './order.dart'; 
import 'returnImages.dart';

class OrderReturn {
  final int id;
  final User user;
  final Product product;
  final int qty;
  final String? status;
  final String? reason;
  final double? return_amount;
  final String? description;
  final DateTime? return_date;
  final List<ReturnImage>? images;  // Thêm danh sách ảnh

  OrderReturn({
    required this.id,
    required this.user,
    required this.product,
    required this.qty,
    this.status,
    this.reason,
    this.return_amount,
    this.description,
    this.return_date,
    this.images,  // Khởi tạo danh sách ảnh
  });

factory OrderReturn.fromJson(Map<String, dynamic> json) {
  var imageList = json['images'] as List?;  // Lấy danh sách ảnh
  List<ReturnImage> images = [];
  if (imageList != null) {
    images = imageList.map((image) {
      if (image is Map<String, dynamic>) {
        return ReturnImage.fromJson(image); // Nếu phần tử là một Map
      } else {
        return ReturnImage.fromJson({'image_path': image, 'order_return_id': json['id']}); // Nếu phần tử là chuỗi
      }
    }).toList();
  }

  return OrderReturn(
    id: json['id'] ?? 0,
    user: User.fromJson(json['user'] ?? {}),
    product: Product.fromJson(json['product'] ?? {}),
    qty: json['qty'] ?? 0,
    status: json['status'] as String? ?? 'Unknown',
    reason: json['reason'] as String? ?? 'No reason provided',
    return_amount: (json['return_amount'] as num?)?.toDouble() ?? 0.0,
    description: json['description'] as String? ?? 'No description available',
    return_date: json['return_date'] != null
        ? DateTime.tryParse(json['return_date']) ?? DateTime.now()
        : DateTime.now(),
    images: images,
  );
}




  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'product': product.toJson(),
      'qty': qty,
      'status': status,
      'reason': reason,
      'return_amount': return_amount,
      'description': description,
      'return_date': return_date?.toIso8601String(),
      'images': images?.map((e) => e.toJson()).toList(),  // Chuyển danh sách ảnh thành JSON
    };
  }
}

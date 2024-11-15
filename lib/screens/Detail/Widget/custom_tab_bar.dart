import 'package:flutter/material.dart';
import 'dart:convert';  
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/review.dart';
import 'package:flutter_ecommerce/constants.dart';

class CustomTabBarView extends StatelessWidget {
  final TabController tabController;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Product product;
  final List<Review> reviews;

  const CustomTabBarView({
    Key? key,
    required this.tabController,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.product,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TabBar với hiệu ứng khi nhấn
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? kprimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ['Description', 'Information', 'Review'][index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(
          height: 250, // Chiều cao cho TabBarView
          child: TabBarView(
            controller: tabController,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.description ?? "Product description not available."),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Brand"),
                          subtitle: Text(product.brand?.brandName ?? 'N/A'),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Material"),
                          subtitle: Text(product.material?.materialName ?? 'N/A'),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Size"),
                          subtitle: Text(product.size?.sizeName ?? 'N/A'),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Color"),
                          subtitle: Text(product.color ?? 'N/A'),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Weight"),
                          subtitle: Text(product.weight != null
                              ? '${product.weight} kg'
                              : 'N/A'),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Height"),
                          subtitle: Text(product.height != null
                              ? '${product.height} cm'
                              : 'N/A'),
                        ),
                      ),
                       Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: const Text("Length"),
                          subtitle: Text(product.length != null
                              ? '${product.length} cm'
                              : 'N/A'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: reviews.isEmpty
                    ? Text("There are no reviews yet.")
                    : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ảnh người dùng
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: review.user?.thumbnail != null
                                        ? MemoryImage(
                                            base64Decode(review.user!.thumbnail!),
                                          )
                                        : NetworkImage('https://via.placeholder.com/150') as ImageProvider,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Tên người dùng
                                        Text(
                                          review.user?.userName ?? "Anonymous",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // ngay review
                                         Text(
                                          "${review.getFormattedDate()}",
                                          style: TextStyle(
                                            fontSize: 12, // Thay đổi font-size cho ngày
                                            color: Colors.grey,
                                          ),
                                        ),
                                        // Hiển thị số sao
                                        Row(
                                          children: List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < (review.ratingValue ?? 0)  // Xử lý trường hợp null
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 20,
                                            );
                                          }),
                                        ),
                      
                                      
                                        SizedBox(height: 5),
                                        // Comment
                                        Text(review.comment ?? "No comment"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

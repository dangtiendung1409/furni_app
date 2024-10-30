import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/screens/Home/Widget/product_cart.dart';
import 'package:flutter_ecommerce/screens/Home/Widget/search_bar.dart';
import '../../models/category.dart';
import 'Widget/home_app_bar.dart';
import 'Widget/image_slider.dart';
import '../../service/CategoryService.dart';
import '../../service/ProductService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0;
  List<Category> categoriesList = [];
  List<Product> productsList = [];
  bool isLoadingCategories = true;
  bool isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }
Future<void> fetchCategories() async {
  try {
    CategoryService categoryService = CategoryService();
    categoriesList = await categoryService.fetchCategories();

    // Kiểm tra xem danh sách danh mục có ít nhất một mục không
    if (categoriesList.isNotEmpty && categoriesList[0].id != null) {
      await fetchProductsByCategory(categoriesList[0].id); // Lấy sản phẩm theo danh mục đầu tiên
    } else {
      // Thông báo rằng không có danh mục nào được tìm thấy
      print('No categories found or first category ID is null');
    }
  } catch (e) {
    print('Error fetching categories: $e');
  } finally {
    setState(() {
      isLoadingCategories = false;
    });
  }
}


 Future<void> fetchProductsByCategory(int categoryId) async {
  // Kiểm tra categoryId trước khi thực hiện yêu cầu
  if (categoryId == null) {
    print('Invalid category ID');
    return;
  }

  setState(() {
    isLoadingProducts = true;
  });

  try {
    ProductService productService = ProductService();
    productsList = await productService.fetchProductsByCategory(categoryId);
  } catch (e) {
    print('Error fetching products: $e');
  } finally {
    setState(() {
      isLoadingProducts = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const CustomAppBar(),
              const SizedBox(height: 20),
              const MySearchBAR(),
              const SizedBox(height: 20),
              ImageSlider(
                currentSlide: currentSlider,
                onChange: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              isLoadingCategories
                  ? Center(child: CircularProgressIndicator())
                  : categoryItems(),

              const SizedBox(height: 20),
              if (selectedIndex == 0)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Special For You",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              isLoadingProducts
                  ? Center(child: CircularProgressIndicator())
                  : productsList.isEmpty
                      ? Center(child: Text("No products available"))
                      : GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: productsList.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: productsList[index],
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox categoryItems() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              fetchProductsByCategory(categoriesList[index].id); // Cập nhật sản phẩm theo danh mục
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedIndex == index ? Colors.blue[200] : Colors.transparent,
              ),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.memory(
                        categoriesList[index].getImageFromBase64(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    categoriesList[index].categoryName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

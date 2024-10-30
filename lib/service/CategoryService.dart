// services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  final String apiUrl = "http://10.0.2.2:3000/api/category";

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Ánh xạ dữ liệu JSON thành danh sách đối tượng Category
        List<Category> categories = data.map((json) => Category.fromJson(json)).toList();
        
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}

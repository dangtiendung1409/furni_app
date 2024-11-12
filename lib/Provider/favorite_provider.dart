import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/favorite.dart';
import '../service/favorite_service.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  final List<Favorite> _favorites = [];
  final FavoriteService _favoriteService = FavoriteService();

  List<Favorite> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavorites(); // Khi khởi tạo, tải danh sách yêu thích
  }

  // Kiểm tra sản phẩm có trong danh sách yêu thích không
  bool isExist(Product product) {
    return _favorites.any((favorite) => favorite.productId == product.id);
  }
Future<void> fetchFavorites(String token) async {
    try {
      final favorites = await _favoriteService.fetchFavorites(token);
      _favorites.clear();
      _favorites.addAll(favorites);
      notifyListeners(); // Cập nhật UI
    } catch (e) {
      print('Failed to fetch favorites: $e');
    }
  }
  // Thêm/xóa sản phẩm khỏi danh sách yêu thích
  Future<void> toggleFavorite(Product product, String token) async {
    try {
      if (isExist(product)) {
        // Xóa khỏi danh sách yêu thích
        await _favoriteService.removeFromFavorite(product.id!, token);
        _favorites.removeWhere((favorite) => favorite.productId == product.id);
      } else {
        // Thêm vào danh sách yêu thích
        final favorite = await _favoriteService.addToFavorite(product.id!, token);
        _favorites.add(favorite);
      }

      // Lưu lại danh sách yêu thích vào SharedPreferences
      await _saveFavorites();
      notifyListeners(); // Cập nhật UI ngay lập tức
    } catch (e) {
      print('Failed to toggle favorite: $e');
    }
  }

  // Lưu danh sách yêu thích vào SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteJsonList = _favorites.map((favorite) => jsonEncode(favorite.toJson())).toList();
    await prefs.setStringList('favorites', favoriteJsonList);
  }

  // Tải danh sách yêu thích từ SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteJsonList = prefs.getStringList('favorites');

    if (favoriteJsonList != null) {
      _favorites.clear();
      for (String favoriteJson in favoriteJsonList) {
        _favorites.add(Favorite.fromJson(jsonDecode(favoriteJson)));
      }
    }
    notifyListeners(); // Cập nhật UI sau khi tải dữ liệu
  }
}

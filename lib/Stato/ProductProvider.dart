import 'package:flutter/material.dart';
import '../Core/dbQueryProduct.dart';
import '../Model/ProductModel.dart';

class ProductProvider with ChangeNotifier {
  final DbQueryProduct _dbQueryProduct = DbQueryProduct();

  final List<Product> _products = [];
  List<Store> _stores = [];
  List<Product> _recommendedProducts = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Store> get stores => _stores;
  List<Product> get recommendedProducts => _recommendedProducts;
  bool get isLoading => _isLoading;

  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // In parallel
      await Future.wait([fetchStores(), fetchRecommended()]);
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchStores() async {
    _stores = await _dbQueryProduct.getStores();
    notifyListeners();
  }

  Future<void> fetchRecommended() async {
    _recommendedProducts = await _dbQueryProduct.getRecommendedProducts();
    notifyListeners();
  }

  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  Future<void> searchProducts(String query) async {
    try {
      _isLoading = true;
      notifyListeners();
      _searchResults = await _dbQueryProduct.searchProducts(query);
    } catch (e) {
      print("Error searching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

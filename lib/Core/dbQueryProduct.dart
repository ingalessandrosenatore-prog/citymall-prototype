import 'package:supabase_flutter/supabase_flutter.dart';
import '../Model/ProductModel.dart';
import 'dbConfig.dart';

class DbQueryProduct {
  final SupabaseClient _client = DbConfig.client;

  Future<List<Category>> getCategories() async {
    final response = await _client.from('CATEGORIES').select();
    return (response as List).map((e) => Category.fromJson(e)).toList();
  }

  Future<List<Store>> getStores() async {
    // Fetch stores. Should ideally support pagination.
    final response = await _client.from('STORES').select('*, store_photos(*)');
    return (response as List).map((e) => Store.fromJson(e)).toList();
  }

  // Example of "Around me" query attempting to use a PostGIS RPC function
  // If function doesn't exist, this will fail, so we might fallback to fetching all and filtering in Dart
  // (not scalable but works for demo).
  Future<List<Store>> getStoresNearby(
    double lat,
    double lng,
    double radiusKm,
  ) async {
    try {
      final response = await _client.rpc(
        'get_stores_nearby',
        params: {'lat': lat, 'lng': lng, 'radius_km': radiusKm},
      );
      return (response as List).map((e) => Store.fromJson(e)).toList();
    } catch (e) {
      print("RPC get_stores_nearby failed, falling back to all stores: $e");
      // Fallback
      return getStores(); // Filter locally in logic/UI
    }
  }

  Future<List<Product>> getProductsByStore(int storeId) async {
    final response = await _client
        .from('PRODUCTS')
        .select('*, product_variants(*, variant_photos(*))')
        .eq('store_id', storeId);
    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getRecommendedProducts() async {
    // Arbitrary logic for "Recommended" - maybe active products sorted by recent?
    final response = await _client
        .from('PRODUCTS')
        .select('*, product_variants(*, variant_photos(*))')
        .limit(10);
    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await _client
        .from('PRODUCTS')
        .select('*, product_variants(*, variant_photos(*))')
        .ilike('name', '%$query%');
    return (response as List).map((e) => Product.fromJson(e)).toList();
  }
}

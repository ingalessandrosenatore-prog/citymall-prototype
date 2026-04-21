import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Model/OrderModel.dart';

import '../Core/dbConfig.dart';

class CartProvider with ChangeNotifier {
  final SupabaseClient _client = DbConfig.client;

  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;

  Future<void> loadCart(int customerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Find active cart for customer
      final response = await _client
          .from('CARTS')
          .select(
            '*, cart_items(*, product_variants(*, product:product_id(*)))',
          ) // Nested fetch potentially
          // Note: product_variants has product_id. We might need deep select.
          .eq('customer_id', customerId)
          .maybeSingle(); // Assuming one active cart or logic to handle multiple

      if (response != null) {
        _cart = Cart.fromJson(response);
      } else {
        // Create new cart if none? Or wait for add item.
        _cart = null;
      }
    } catch (e) {
      print("Error loading cart: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(
    int customerId,
    int variantId,
    int quantity,
    double price,
  ) async {
    // 1. Ensure Cart exists
    if (_cart == null) {
      final cartRes = await _client
          .from('CARTS')
          .insert({
            'customer_id': customerId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      _cart = Cart.fromJson(cartRes);
    }

    // 2. Add Item (Trigger handles subtotal)
    await _client.from('CART_ITEMS').insert({
      'cart_id': _cart!.id,
      'variant_id': variantId,
      'quantity': quantity,
      'unit_price': price,
    });

    // 3. Reload
    await loadCart(customerId);
  }

  Future<void> updateQuantity(int itemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    await _client
        .from('CART_ITEMS')
        .update({
          'quantity': newQuantity,
          // Trigger updates subtotal
        })
        .eq('id', itemId);

    // Reload to get updated subtotal
    if (_cart != null) await loadCart(_cart!.customerId);
  }

  Future<void> removeFromCart(int itemId) async {
    await _client.from('CART_ITEMS').delete().eq('id', itemId);
    if (_cart != null) await loadCart(_cart!.customerId);
  }

  double get total {
    if (_cart == null) return 0.0;
    return _cart!.items.fold(0, (sum, item) => sum + item.subtotal);
  }
}

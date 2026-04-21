import 'ProductModel.dart';

class Cart {
  final int id;
  final int customerId;
  final DateTime createdAt;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.customerId,
    required this.createdAt,
    this.items = const [],
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var loadedItems = <CartItem>[];
    if (json['cart_items'] != null) {
      loadedItems = (json['cart_items'] as List)
          .map((i) => CartItem.fromJson(i))
          .toList();
    }
    return Cart(
      id: json['id'],
      customerId: json['customer_id'],
      createdAt: DateTime.parse(json['created_at']),
      items: loadedItems,
    );
  }
}

class CartItem {
  final int id;
  final int cartId;
  final int variantId;
  final int quantity;
  final double unitPrice;
  final double subtotal; // Trigger calculated
  final ProductVariant? variant;

  CartItem({
    required this.id,
    required this.cartId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.variant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      variant: json['product_variants'] != null
          ? ProductVariant.fromJson(json['product_variants'])
          : null,
    );
  }
}

class Order {
  final int id;
  final int customerId;
  final int storeId;
  final int? riderId;
  final String status;
  final double totalAmount;
  final double deliveryCost;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.customerId,
    required this.storeId,
    this.riderId,
    required this.status,
    required this.totalAmount,
    required this.deliveryCost,
    required this.createdAt,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var loadedItems = <OrderItem>[];
    if (json['order_items'] != null) {
      loadedItems = (json['order_items'] as List)
          .map((i) => OrderItem.fromJson(i))
          .toList();
    }
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      storeId: json['store_id'],
      riderId: json['rider_id'],
      status: json['status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      deliveryCost: (json['delivery_cost'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      items: loadedItems,
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int variantId;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      variantId: json['product_variant_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

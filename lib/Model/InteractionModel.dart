class SearchHistory {
  final int id;
  final int customerId;
  final String queryText;
  final double latAtSearch;
  final double longAtSearch;
  final DateTime createdAt;

  SearchHistory({
    required this.id,
    required this.customerId,
    required this.queryText,
    required this.latAtSearch,
    required this.longAtSearch,
    required this.createdAt,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'],
      customerId: json['customer_id'],
      queryText: json['query_text'],
      latAtSearch: (json['lat_at_search'] as num).toDouble(),
      longAtSearch: (json['long_at_search'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Wishlist {
  final int id;
  final int customerId;
  final int productId;
  final DateTime createdAt;

  Wishlist({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.createdAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class StorePhoto {
  final int id;
  final int storeId;
  final String url;
  final bool isPrimary;
  final bool isActive;

  StorePhoto({
    required this.id,
    required this.storeId,
    required this.url,
    required this.isPrimary,
    required this.isActive,
  });

  factory StorePhoto.fromJson(Map<String, dynamic> json) {
    return StorePhoto(
      id: json['id'],
      storeId: json['store_id'],
      url: json['url'],
      isPrimary: json['is_primary'],
      isActive: json['is_active'],
    );
  }
}

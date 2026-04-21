class Category {
  final int id;
  final int? parentId;
  final String name;

  Category({required this.id, this.parentId, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
    );
  }
}

class Store {
  final int id;
  final int merchantId;
  final String name;
  final DateTime createdAt;
  final String?
  mainImageUrl; // From relation or separate query usually, but good to have in model if joined

  Store({
    required this.id,
    required this.merchantId,
    required this.name,
    required this.createdAt,
    this.mainImageUrl,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      merchantId: json['merchant_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      mainImageUrl:
          json['store_photos'] != null &&
              (json['store_photos'] as List).isNotEmpty
          ? (json['store_photos'] as List).firstWhere(
              (e) => e['is_primary'] == true,
              orElse: () => (json['store_photos'] as List).first,
            )['url']
          : null,
    );
  }
}

class Product {
  final int id;
  final int storeId;
  final int categoryId;
  final String name;
  final String description;
  final DateTime createdAt;
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.storeId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.createdAt,
    this.variants = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var loadedVariants = <ProductVariant>[];
    if (json['product_variants'] != null) {
      loadedVariants = (json['product_variants'] as List)
          .map((v) => ProductVariant.fromJson(v))
          .toList();
    }

    return Product(
      id: json['id'],
      storeId: json['store_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      variants: loadedVariants,
    );
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String sku;
  final int? barCode;
  final double price;
  final int stockQty;
  final String? variantImageUrl;
  final List<VariantAttributeValue> attributeValues;
  final List<VariantPhoto> photos;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.sku,
    this.barCode,
    required this.price,
    required this.stockQty,
    this.variantImageUrl,
    this.attributeValues = const [],
    this.photos = const [],
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    var loadedAttributes = <VariantAttributeValue>[];
    if (json['variant_attribute_values'] != null) {
      loadedAttributes = (json['variant_attribute_values'] as List)
          .map((a) => VariantAttributeValue.fromJson(a))
          .toList();
    }

    var loadedPhotos = <VariantPhoto>[];
    if (json['variant_photos'] != null) {
      loadedPhotos = (json['variant_photos'] as List)
          .map((p) => VariantPhoto.fromJson(p))
          .toList();
    }

    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      sku: json['sku'],
      barCode: json['barCode'],
      price: (json['price'] as num).toDouble(),
      stockQty: json['stock_qty'],
      variantImageUrl: json['variant_image_url'],
      attributeValues: loadedAttributes,
      photos: loadedPhotos,
    );
  }
}

class VariantAttributeValue {
  final int id;
  final int productVariantId;
  final int attributeId;
  final String value;
  // Optional: include attribute name if joined
  final String? attributeName;

  VariantAttributeValue({
    required this.id,
    required this.productVariantId,
    required this.attributeId,
    required this.value,
    this.attributeName,
  });

  factory VariantAttributeValue.fromJson(Map<String, dynamic> json) {
    return VariantAttributeValue(
      id: json['id'],
      productVariantId: json['product_variant_id'],
      attributeId: json['attribute_id'],
      value: json['value'],
      attributeName: json['attributes'] != null
          ? json['attributes']['name']
          : null,
    );
  }
}

class VariantPhoto {
  final int id;
  final int variantId;
  final String url;
  final bool isPrimary;
  final int orderIndex;

  VariantPhoto({
    required this.id,
    required this.variantId,
    required this.url,
    required this.isPrimary,
    required this.orderIndex,
  });

  factory VariantPhoto.fromJson(Map<String, dynamic> json) {
    return VariantPhoto(
      id: json['id'],
      variantId: json['variant_id'],
      url: json['url'],
      isPrimary: json['is_primary'],
      orderIndex: json['order_index'],
    );
  }
}

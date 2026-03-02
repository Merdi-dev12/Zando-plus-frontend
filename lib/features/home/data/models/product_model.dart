import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.name,
    required super.description,
    required super.categoryId,
    required super.price,
    required super.quantity,
    required super.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id:          json['id'] as int?,
      name:        (json['name'] as String?)        ?? '',
      description: (json['description'] as String?) ?? '',
      categoryId:  (json['category_id'] as int?)    ?? 0,
      price:       (json['price'] as String?)        ?? '0',
      quantity:    (json['quantity'] as int?)         ?? 0,
      imageUrl:    (json['image_url'] as String?)     ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':          id,
      'name':        name,
      'description': description,
      'category_id': categoryId,
      'price':       price,
      'quantity':    quantity,
      'image_url':   imageUrl,
    };
  }
}
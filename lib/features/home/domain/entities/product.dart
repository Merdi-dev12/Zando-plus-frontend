import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? id;
  final String name;
  final String description;
  final int categoryId;
  final String price;
  final int quantity;
  final String imageUrl;
  final double rating; 
  final bool isFavorite; 

  const Product({
    this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.rating = 0.0, 
    this.isFavorite = false, 
  });

  bool get isInStock => quantity > 0;

  /// Copie avec modification partielle
  Product copyWith({
    int? id,
    String? name,
    String? description,
    int? categoryId,
    String? price,
    int? quantity,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryId,
        price,
        quantity,
        imageUrl,
      ];
}
import 'package:equatable/equatable.dart';

/// Entité pure — représente une catégorie de produits.
class Category extends Equatable {
  final int id;
  final String name;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Category copyWith({
    int? id,
    String? name,
    String? imageUrl,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl];
}
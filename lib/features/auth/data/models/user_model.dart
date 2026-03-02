import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.address,
    super.avatar,
    required super.role,
  });

  // Conversion JSON -> Modèle
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      avatar: json['avatar'],
      role: json['role'] ?? 'user',
    );
  }

  // Conversion Modèle -> JSON (utile pour les mises à jour de profil)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'avatar': avatar,
      'role': role,
    };
  }
}

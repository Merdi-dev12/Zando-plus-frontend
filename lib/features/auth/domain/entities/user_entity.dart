class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? address;
  final String? avatar;
  final String role;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    this.avatar,
    required this.role,
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';
import '../../../../core/api/api_client.dart';

class AuthNotifier extends StateNotifier<UserEntity?> {
  AuthNotifier() : super(null);

  Future<void> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        state = UserModel.fromJson(userData);
      }
    } catch (e) {
      state = null;
      rethrow; // Permet à l'UI d'afficher une erreur
    }
  }

  void logout() => state = null;
}

final authProvider =
    StateNotifierProvider<AuthNotifier, UserEntity?>((ref) => AuthNotifier());

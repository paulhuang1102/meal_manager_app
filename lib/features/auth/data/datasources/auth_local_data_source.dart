import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });


  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      if (username == AppConstants.defaultUsername &&
          password == AppConstants.defaultPassword) {
        final user = UserModel(username: username);

        await sharedPreferences.setBool(StorageKeys.isLoggedIn, true);
        await sharedPreferences.setString(
          StorageKeys.currentUser,
          user.toJsonString(),
        );

        return user;
      } else {
        throw AuthException('Invalid username or password');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw CacheException('Failed to login: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await sharedPreferences.setBool(StorageKeys.isLoggedIn, false);
      await sharedPreferences.remove(StorageKeys.currentUser);
    } catch (e) {
      throw CacheException('Failed to logout: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final isLoggedIn = await this.isLoggedIn();
      if (!isLoggedIn) {
        return null;
      }

      final userJson = sharedPreferences.getString(StorageKeys.currentUser);
      if (userJson == null) {
        return null;
      }

      return UserModel.fromJsonString(userJson);
    } catch (e) {
      throw CacheException('Failed to get current user: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(StorageKeys.isLoggedIn) ?? false;
  }
}

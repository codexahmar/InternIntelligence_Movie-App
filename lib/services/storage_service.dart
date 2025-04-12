import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class StorageService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    if (!users.any((u) => u.email == user.email)) {
      users.add(user);
      await prefs.setString(
        _usersKey,
        jsonEncode(users.map((u) => u.toJson()).toList()),
      );
    }
  }

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];

    final usersList = jsonDecode(usersJson) as List;
    return usersList.map((json) => User.fromJson(json)).toList();
  }

  Future<User?> login(String email, String password) async {
    final users = await getUsers();
    final user = users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<void> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    final index = users.indexWhere((u) => u.email == user.email);
    if (index != -1) {
      users[index] = user;
      await prefs.setString(
        _usersKey,
        jsonEncode(users.map((u) => u.toJson()).toList()),
      );

      // Update current user if it's the same user
      final currentUser = await getCurrentUser();
      if (currentUser?.email == user.email) {
        await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      }
    }
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;

    return User.fromJson(jsonDecode(userJson));
  }
}

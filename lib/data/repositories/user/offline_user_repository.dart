import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:users_management/data/models/user.dart';
import 'package:users_management/data/repositories/user/base_user_repository.dart';
import 'package:http/http.dart' as http;

class OfflineUserRepository implements BaseUserRepository {
  final String apiUrl = 'http://localhost:3001/users';
  @override
  EitherUser<User> addUser(User user) async {
    try {
      const storage = FlutterSecureStorage();
      final String? jwtToken = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(user.toMap()),
      );
      if (response.statusCode == 200) {
        return right(user); // No error
      } else {
        return left(
            'Unauthorized: Token may be expired or invalid'); // Return the error message
      }
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<String> deleteUser(String userId) async {
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final Uri uri = Uri.parse('$apiUrl/$userId');
    final response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      return right(jsonDecode(response.body)['message']);
    } else {
      // Handle errors
      return left('error updating user');
    }
  }

  @override
  EitherUser<List<User>> getAllUsers() async {
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final Uri uri = Uri.parse(apiUrl);
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      // Parse the response
      final List<dynamic> usersJson = jsonDecode(response.body);

      // Convert the JSON data to a list of User objects
      final List<User> users = List<User>.from(
        usersJson.map((user) => User.fromJson(user)),
      );

      return right(users);
    } else {
      // Handle errors
      return left('error fetching users');
    }
  }

  @override
  EitherUser<User> updateUser(User user) async {
    const storage = FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'token');
    final Uri uri = Uri.parse('$apiUrl/${user.id}');
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return right(user);
    } else {
      // Handle errors
      return left('error updating user');
    }
  }
}

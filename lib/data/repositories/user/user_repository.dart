import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:users_management/data/models/user.dart';

import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  EitherUser<User> addUser(User user, String? password) async {
    try {
      await _firebaseFirestore.collection('users').add({'user': user.toMap()});
      return right(user);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<String> deleteUser(String userId) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).delete();
      return right(userId);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<List<User>> getAllUsers() async {
    List<User> users = [];
    try {
      var snapshot = await _firebaseFirestore.collection('users').get();
      users = snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
      return right(users);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<User> updateUser(User user) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update({'user': user.toMap()});
      return right(user);
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }
}

import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:users_management/data/models/user.dart' as user_model;

import 'base_authentication_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;
  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firebaseFirestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  EitherUser<user_model.User> googleSignInUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Google sign-in successful
        // Retrieve the Google sign-in authentication details
        if (!_firebaseFirestore.doc(googleUser.id).isNull) {
          var doc = await _firebaseFirestore.doc(googleUser.id).get();
          user_model.User currentUser = user_model.User.fromSnapshot(doc);
          return right(currentUser);
        } else {
          return left('user is not registered in the system');
        }
      } else {
        // Google sign-in canceled by the user
        return left('user cancelled authentication');
      }
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }

  @override
  EitherUser<String> signOutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      googleSignIn.signOut();
      _auth.signOut();
      return right('signed out successfully');
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }
}

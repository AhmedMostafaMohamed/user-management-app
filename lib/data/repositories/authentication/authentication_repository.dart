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
  final GoogleSignIn _googleSignIn;
  AuthRepository({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? auth,
    FirebaseFirestore? firebaseFirestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  EitherUser<User> googleSignInUser() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        if (userCredential.user != null) {
          return right(userCredential.user!);
        } else {
          return left('User is not found');
        }
      } catch (e) {
        return left(kDebugMode
            ? e.toString()
            : 'error occurred, please try again later');
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(authCredential);
          if (userCredential.user != null) {
            return right(userCredential.user!);
          } else {
            return left('User is not found');
          }
        } on FirebaseAuthException catch (e) {
          return left(e.code);
        }
      } else {
        return left('error occurred, please try again later');
      }
    }
  }

  @override
  EitherUser<String> signOutUser() async {
    try {
      _googleSignIn.signOut();
      _auth.signOut();
      return right('signed out successfully');
    } catch (e) {
      return left(
          kDebugMode ? e.toString() : 'error occurred, please try again later');
    }
  }
}

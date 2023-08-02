import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<bool?> checkSystemAccess(String email, String accessKey) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection('users')
            .where('user.email', isEqualTo: email)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document found (assuming email is unique)
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          querySnapshot.docs.first;

      // Check if the "user" field exists and is a map
      if (documentSnapshot.data()!.containsKey('user') &&
          documentSnapshot.data()!['user'] is Map) {
        final Map<String, dynamic> userMap = documentSnapshot.data()!['user'];

        // Check if the "systemAccess" field exists and is a map
        if (userMap.containsKey('systemAccess') &&
            userMap['systemAccess'] is Map) {
          final Map<String, dynamic> systemAccessMap = userMap['systemAccess'];

          // Check if the accessKey exists in the "systemAccess" map and return its value
          if (systemAccessMap.containsKey(accessKey) &&
              systemAccessMap[accessKey] is bool) {
            return systemAccessMap[accessKey];
          }
        }
      }
    }

    // Return null if the email, "user", or "systemAccess" fields are missing,
    // or if the accessKey is not found in the "systemAccess" map.
    return null;
  }

  @override
  EitherUser<User> googleSignInUser() async {
    await _googleSignIn.signOut();

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        if (userCredential.user != null) {
          bool? accessValue = await checkSystemAccess(
              userCredential.user!.email!, 'Users management');
          if (accessValue == true) {
            return right(userCredential.user!);
          } else if (accessValue == false) {
            return left(
                'the user: ${userCredential.user!.email!} does not have access for this system');
          } else {
            return left('User is not found');
          }
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
            bool? accessValue = await checkSystemAccess(
                userCredential.user!.email!, 'Users management');

            if (accessValue == true) {
              return right(userCredential.user!);
            } else if (accessValue == false) {
              return left(
                  'the user: ${userCredential.user!.email!} does not have access for this system');
            } else {
              return left('User is not found');
            }
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

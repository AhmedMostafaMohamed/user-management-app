import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseAuthRepository {
  EitherUser<User> googleSignInUser();
  EitherUser<String> signOutUser();
}

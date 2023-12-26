import 'package:dartz/dartz.dart';


typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseAuthRepository {
  EitherUser<String> googleSignInUser();
  EitherUser<String> emailPasswordSignIn(String email, String password);
  EitherUser<String> signOutUser();
}

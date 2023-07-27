import 'package:dartz/dartz.dart';

import '../../models/user.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseAuthRepository {
  EitherUser<User> googleSignInUser();
  EitherUser<String> signOutUser();
}

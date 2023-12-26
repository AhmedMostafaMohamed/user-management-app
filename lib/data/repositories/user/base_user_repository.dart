import 'package:dartz/dartz.dart';
import 'package:users_management/data/models/user.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseUserRepository {
  EitherUser<List<User>> getAllUsers();
  EitherUser<User> addUser(User user);
  EitherUser<String> deleteUser(String userId);
  EitherUser<User> updateUser(User user);
}

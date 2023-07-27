import 'package:dartz/dartz.dart';
import 'package:users_management/data/models/user.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseUserRepository {
  EitherUser<Stream<List<User>>> getAllUsers();
  Future<void> addUser(User user);
  Future<void> deleteUser(String userId);
  EitherUser<User> updateUser(User user);
}

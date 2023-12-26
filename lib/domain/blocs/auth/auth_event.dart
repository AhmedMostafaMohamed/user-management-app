part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {}

class EmailPasswordSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const EmailPasswordSignInEvent({required this.email, required this.password});
}

class SignOutEvent extends AuthEvent {}

part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class LoadingState extends UserState {}

class LoadedState extends UserState {
  final List<User> users;

  const LoadedState({required this.users});
}

class UserAddedState extends UserState {}

class UserUpdatedState extends UserState {}

class UserDeletedState extends UserState {}

class ErrorState extends UserState {
  final String errorMessage;
  const ErrorState({required this.errorMessage});
}

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final User user;
  const UpdateUserEvent({required this.user});
}

class DeleteUserEvent extends UserEvent {
  final String userId;
  const DeleteUserEvent({required this.userId});
}

class AddUserEvent extends UserEvent {
  final User user;
  const AddUserEvent({required this.user});
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum Role {
  admin,
  user,
}

class User extends Equatable {
  final String id;
  final String email;
  final Role role;
  final Map<String, bool> systemAccess;

  const User({
    required this.email,
    required this.role,
    required this.systemAccess,
    this.id = '0',
  });
  factory User.empty() {
    return const User(email: '', role: Role.user, systemAccess: {});
  }

  @override
  List<Object?> get props => [
        id,
        email,
        role,
        systemAccess,
      ];
  static User fromSnapshot(DocumentSnapshot snap) {
    switch (snap['user']['role']) {
      case 'admin':
        User user = User(
          email: snap['user']['email'],
          role: Role.admin,
          id: snap.id,
          systemAccess: snap['user']['systemAccess'],
        );
        return user;
      case 'user':
        User user = User(
          email: snap['user']['email'],
          role: Role.user,
          id: snap.id,
          systemAccess: snap['user']['systemAccess'],
        );
        return user;

      default:
        throw ArgumentError('Invalid role value: ${snap['user']['role']}');
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'role': role.toString().split('.').last,
      'systemAccess': systemAccess,
    };
  }
}

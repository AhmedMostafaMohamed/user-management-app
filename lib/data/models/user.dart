import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum Role {
  admin,
  user,
}

class User extends Equatable {
  final String id;
  final String email;
  final String password;
  final Role role;
  final Map<String, bool> systemAccess;

  const User({
    required this.email,
    required this.role,
    required this.systemAccess,
    required this.password,
    this.id = '0',
  });
  factory User.empty() {
    return const User(email: '', password: '', role: Role.user, systemAccess: {
      'Expense management': false,
      'POS': false,
      'Workers scheduler': false,
      'Users management': false,
      'Reporting system': false,
    });
  }

  @override
  List<Object?> get props => [
        id,
        email,
        password,
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
          systemAccess: Map<String, bool>.from(snap['user']['systemAccess']),
          password: snap['user']['password'],
        );
        return user;
      case 'user':
        User user = User(
          email: snap['user']['email'],
          role: Role.user,
          id: snap.id,
          systemAccess: Map<String, bool>.from(snap['user']['systemAccess']),
          password: snap['user']['password'],
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
      'password': password,
    };
  }

  User copyWith({
    String? email,
    Role? role,
    Map<String, bool>? systemAccess,
    String? password,
  }) {
    return User(
      id: id,
      email: email ?? this.email,
      role: role ?? this.role,
      systemAccess: systemAccess ?? Map.from(this.systemAccess),
      password: password ?? this.password,
    );
  }

  static User fromJson(Map json) {
    return User(
        email: json['email'],
        id: json['_id'],
        password: json['password'],
        role: json['role'] == 'admin' ? Role.admin : Role.user,
        systemAccess: Map<String, bool>.from(json['systemAccess']));
  }
}

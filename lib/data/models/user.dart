
import 'package:equatable/equatable.dart';

enum Role {
  admin,
  user,
}

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final num hourRate;
  final String email;
  final Role role;
  final Map<String, bool> systemAccess;

  const User({
    required this.hourRate,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.systemAccess,
    this.id = '0',
  });
  factory User.empty() {
    return const User(
        hourRate: 0,
        email: '',
        firstName: '',
        lastName: '',
        role: Role.user,
        systemAccess: {
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
        role,
        systemAccess,
        firstName,
        lastName,
        hourRate,
      ];
  static User fromSnapshot( snap) {
    return User(
      hourRate: snap['user']['hourRate'],
      firstName: snap['user']['firstName'],
      lastName: snap['user']['lastName'],
      email: snap['user']['email'],
      role: snap['user']['role'] == 'admin' ? Role.admin : Role.user,
      id: snap.id,
      systemAccess: Map<String, bool>.from(snap['user']['systemAccess']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.toString().split('.').last,
      'systemAccess': systemAccess,
      'hourRate': hourRate,
    };
  }

  User copyWith({
    String? email,
    Role? role,
    String? firstName,
    String? lastName,
    Map<String, bool>? systemAccess,
    num? hourRate,
  }) {
   
    return User(
      id: id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      systemAccess: systemAccess ?? Map.from(this.systemAccess),
      hourRate: hourRate ?? this.hourRate,
    );
  }

  static User fromJson(Map json) {
    return User(
        email: json['email'],
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        role: json['role'] == 'admin' ? Role.admin : Role.user,
        systemAccess: Map<String, bool>.from(json['systemAccess']),
        hourRate: json['hourRate']);
  }
}

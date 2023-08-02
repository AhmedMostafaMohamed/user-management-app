import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/domain/blocs/auth/auth_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';

import '../../data/models/user.dart' as user_model;
import 'components/users_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final photoURL = currentUser?.photoURL;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Users mangement'),
        actions: [
          IconButton(
              tooltip: 'Refresh',
              onPressed: () {
                BlocProvider.of<UserBloc>(context).add(FetchUsersEvent());
              },
              icon: const Icon(Icons.refresh)),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            child: IconButton(
                tooltip: 'SignOut',
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                },
                icon: const Icon(Icons.power_settings_new_outlined)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
              radius: 20,
              child: photoURL == null
                  ? const Icon(Icons.person,
                      size: 20) // Display a default icon if photoURL is null
                  : null,
            ),
          )
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        bloc: BlocProvider.of(context)..add(FetchUsersEvent()),
        listener: (context, state) {
          if (state is UserAddedState) {
            debugPrint('user added!!');
            var snackBar2 = const SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              content: Text('User is added successfully!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          } else if (state is UserUpdatedState) {
            debugPrint('user updated!!');
            var snackBar2 = const SnackBar(
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              content: Text('User is updated successfully!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          } else if (state is UserDeletedState) {
            debugPrint('user deleted!!');
            var snackBar2 = const SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
              content: Text('User is deleted successfully!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(
              child: Text('error message: ${state.errorMessage}'),
            );
          } else if (state is LoadedState) {
            return UsersList(users: state.users);
          } else {
            return const Center(
              child: Text('unknown state'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/user-details', arguments: user_model.User.empty());
          },
          child: const Icon(Icons.add)),
    );
  }
}

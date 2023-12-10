import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/domain/blocs/auth/auth_bloc.dart';
import 'package:users_management/domain/blocs/locale/locale_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';
import 'package:users_management/shared/components/reusable_dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.usersmanagement),
        actions: [
          ReusableDropdownButton(
            items: const ['English','Arabic',  'German'],
            value: 'English',
            onChanged: (value) {
              late String languageCode;
              if (value == 'English') {
                languageCode = 'en';
              } else if (value == 'Arabic') {
                languageCode = 'ar';
              } else if (value == 'German') {
                languageCode = 'de';
              }
              BlocProvider.of<LocaleBloc>(context)
                  .add(LoadLanguage(locale: Locale(languageCode)));
            },
          ),
          IconButton(
              tooltip: AppLocalizations.of(context)!.refresh,
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
                tooltip: AppLocalizations.of(context)!.signout,
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
            var snackBar2 =  SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!.useradded),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          } else if (state is UserUpdatedState) {
            debugPrint('user updated!!');
            var snackBar2 =  SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!.userupdated),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            Navigator.of(context).pop();
          } else if (state is UserDeletedState) {
            debugPrint('user deleted!!');
            var snackBar2 =  SnackBar(
              backgroundColor: Colors.red,
              duration: const  Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!.userdeleted),
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
            return Center(
              child: Text(AppLocalizations.of(context)!.unknownstate),
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

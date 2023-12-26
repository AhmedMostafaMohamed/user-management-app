import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/user.dart';
import '../../shared/components/confirm_dialog.dart';

class UserDetailsPage extends StatefulWidget {
  final User user;
  final bool isAddingNewUser;

  const UserDetailsPage(
      {super.key, required this.user, required this.isAddingNewUser});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late User _editedUser;
  late Role _selectedRole; // To store the selected role temporarily
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
    // Initialize the _editedUser with a copy of the data from the widget.user
    if (widget.isAddingNewUser) {
      _emailTextEditingController = TextEditingController();
      _passwordTextEditingController = TextEditingController();
      _editedUser = User.empty();
    } else {
      _editedUser = User(
          id: widget.user.id,
          email: widget.user.email,
          role: widget.user.role,
          systemAccess: Map.from(widget.user.systemAccess),
          password: widget.user.password);
    }

    _selectedRole =
        _editedUser.role; // Set the selected role to the current user's role
  }

  void _updateSystemAccess(String key, bool value) {
    setState(() {
      _editedUser = _editedUser.copyWith(
          systemAccess: Map.from(_editedUser.systemAccess));
      _editedUser.systemAccess[key] = value;
    });
  }

  void _saveChanges() {
    // TODO: Implement the logic to save the changes.
    // You can send the _editedUser object to your BLoC or state management approach.
    // The _editedUser contains the updated data that the user has modified.
    if (widget.isAddingNewUser) {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<UserBloc>(context).add(AddUserEvent(
            user: _editedUser.copyWith(
                role: _selectedRole, email: _email, password: _password)));
      }
    } else {
      BlocProvider.of<UserBloc>(context).add(
          UpdateUserEvent(user: _editedUser.copyWith(role: _selectedRole)));
    }
  }

  void _deleteUser() {
    // TODO: Implement the logic to delete the user.
    // You can send the widget.user to your BLoC or state management approach for deletion.
    BlocProvider.of<UserBloc>(context)
        .add(DeleteUserEvent(userId: widget.user.id));
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          message: AppLocalizations.of(context)!.alert,
          onConfirm: () {
            // Confirm button pressed
            // Perform actions here
            _deleteUser();
            Navigator.pop(context); // Close the dialog
          },
          onCancel: () {
            // Cancel button pressed
            Navigator.pop(context); // Close the dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userdetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isAddingNewUser
                    ? TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                        ),
                        controller: _emailTextEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.enteremail;
                          }
          
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      )
                    : Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _editedUser.email,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      if(widget.isAddingNewUser)
                    TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password
                        ),
                        controller: _passwordTextEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.enterpassword;
                          }
          
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      )
                    ,
                const SizedBox(height: 16),
                Text('${AppLocalizations.of(context)!.role}:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!.user),
                        leading: Radio<Role>(
                          value: Role.user,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!.admin),
                        leading: Radio<Role>(
                          value: Role.admin,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('${AppLocalizations.of(context)!.systemaccess}:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _editedUser.systemAccess.entries.map(
                    (entry) {
                      return CheckboxListTile(
                        title: Text(entry.key),
                        value: entry.value,
                        onChanged: (newValue) {
                          _updateSystemAccess(entry.key, newValue ?? false);
                        },
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text(AppLocalizations.of(context)!.savechanges),
                    ),
                    if (!widget.isAddingNewUser)
                      ElevatedButton(
                        onPressed: _showConfirmationDialog,
                        child: Text(AppLocalizations.of(context)!.deleteuser),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

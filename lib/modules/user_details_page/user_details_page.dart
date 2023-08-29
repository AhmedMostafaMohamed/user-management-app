import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';

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
  final _formKey = GlobalKey<FormState>();
  late String _email;

  @override
  void initState() {
    super.initState();
    _email = '';
    // Initialize the _editedUser with a copy of the data from the widget.user
    if (widget.isAddingNewUser) {
      _emailTextEditingController = TextEditingController();
      _editedUser = User.empty();
    } else {
      _editedUser = User(
        id: widget.user.id,
        email: widget.user.email,
        role: widget.user.role,
        systemAccess: Map.from(widget.user.systemAccess),
      );
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
            user: _editedUser.copyWith(role: _selectedRole, email: _email)));
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
          message:
              'Are you sure you want to delete this item? This action cannot be undone.',
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
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isAddingNewUser
                  ? TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      controller: _emailTextEditingController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email';
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
              const SizedBox(height: 16),
              const Text('Role:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('User'),
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
                      title: const Text('Admin'),
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
              const Text('System Access:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                    child: const Text('Save Changes'),
                  ),
                  if (!widget.isAddingNewUser)
                    ElevatedButton(
                      onPressed: _showConfirmationDialog,
                      child: const Text('Delete User'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

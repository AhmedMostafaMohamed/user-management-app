import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:users_management/modules/user_details_page/components/custom_text_field.dart';
import 'package:users_management/modules/user_details_page/components/role_selection_button.dart';
import 'package:users_management/modules/user_details_page/components/system_access_table.dart';
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
  late TextEditingController _firstNameTextEditingController;
  late TextEditingController _lastNameTextEditingController;
  late TextEditingController _passwordTextEditingController;
  late TextEditingController _hourRateTextEditingController;
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late String _firstName;
  late String _lastName;
  late num _hourRate;

  @override
  void initState() {
    super.initState();
    _email = widget.user.email;
    _password = '';
    _firstName = widget.user.firstName;
    _lastName = widget.user.lastName;
    _hourRate = widget.user.hourRate;
    _firstNameTextEditingController = TextEditingController();
    _lastNameTextEditingController = TextEditingController();
    _hourRateTextEditingController = TextEditingController();
    _emailTextEditingController = TextEditingController();
    // Initialize the _editedUser with a copy of the data from the widget.user
    if (widget.isAddingNewUser) {
      _passwordTextEditingController = TextEditingController();

      _editedUser = User.empty();
    } else {
      _editedUser = User(
        firstName: widget.user.firstName,
        lastName: widget.user.lastName,
        id: widget.user.id,
        email: widget.user.email,
        role: widget.user.role,
        hourRate: widget.user.hourRate,
        systemAccess: Map.from(widget.user.systemAccess),
      );
      _firstNameTextEditingController.text = widget.user.firstName;
      _lastNameTextEditingController.text = widget.user.lastName;
      _hourRateTextEditingController.text = widget.user.hourRate.toString();
      _emailTextEditingController.text = widget.user.email;
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
    if (widget.isAddingNewUser) {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<UserBloc>(context).add(AddUserEvent(
          user: _editedUser.copyWith(
              role: _selectedRole,
              email: _email,
              firstName: _firstName,
              lastName: _lastName,
              hourRate: _hourRate),
          password: _password,
        ));
      }
    } else {
      BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(
          user: _editedUser.copyWith(
              role: _selectedRole,
              email: _email,
              firstName: _firstName,
              lastName: _lastName,
              hourRate: _hourRate)));
    }
  }

  void _deleteUser() {
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
                CustomTextField(
                  controller: _emailTextEditingController,
                  label: AppLocalizations.of(context)!.email,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.enteremail;
                    }

                    return null;
                  },
                ),
                if (widget.isAddingNewUser)
                  CustomTextField(
                    isPassword: true,
                    controller: _passwordTextEditingController,
                    label: AppLocalizations.of(context)!.password,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.enterpassword;
                      }

                      return null;
                    },
                  ),
                CustomTextField(
                  controller: _firstNameTextEditingController,
                  label: AppLocalizations.of(context)!.firstname,
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.enterfirstname;
                    }

                    return null;
                  },
                ),
                CustomTextField(
                  controller: _lastNameTextEditingController,
                  label: AppLocalizations.of(context)!.lastname,
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.enterlastname;
                    }

                    return null;
                  },
                ),
                CustomTextField(
                    controller: _hourRateTextEditingController,
                    label: AppLocalizations.of(context)!.hourRate,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.entervalidhourrate;
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _hourRate = double.parse(value);
                      });
                    }),
                const SizedBox(height: 16),
                RoleSelectionButton(
                  role: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value == true ? Role.admin : Role.user;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SystemAccessTable(
                  systems: _editedUser.systemAccess,
                  labels: [
                    AppLocalizations.of(context)!.systemName,
                    AppLocalizations.of(context)!.access
                  ],
                  onAccessChanged: (value, systemName) {
                    _updateSystemAccess(systemName, value ?? false);
                  },
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

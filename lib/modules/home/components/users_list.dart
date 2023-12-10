import 'package:flutter/material.dart';
import '../../../data/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsersList extends StatefulWidget {
  final List<User> users;
  const UsersList({Key? key, required this.users}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<User> filteredUsers = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users;
  }

  void filterUsers(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredUsers = widget.users;
      } else {
        filteredUsers = widget.users
            .where((user) =>
                user.email.toLowerCase().contains(searchTerm.toLowerCase()) ||
                user.role.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  void viewUserDetails(User user) {
    Navigator.of(context).pushNamed('/user-details', arguments: user);
  }

  Color getRoleColor(Role role) {
    if (role == Role.admin) {
      return Colors.blue; // Use your preferred color for 'Admin' role
    } else {
      return Colors.green; // Use your preferred color for 'User' role
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              onChanged: filterUsers,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.search,
                hintText: AppLocalizations.of(context)!.entersearchkeyword,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final roleColor = getRoleColor(user.role);

              return GestureDetector(
                onTap: () {
                  viewUserDetails(user);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                mapRoleName(user.role.name),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  String mapRoleName(String name) {
    if(name == 'admin'){
      return AppLocalizations.of(context)!.admin;
    }else{
      return AppLocalizations.of(context)!.user;
    }
    
  }
}

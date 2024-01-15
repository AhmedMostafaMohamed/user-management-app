import 'package:flutter/material.dart';
import 'package:users_management/data/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoleSelectionButton extends StatelessWidget {
  final Function(bool)? onChanged;
  final Role role;
  const RoleSelectionButton({super.key, this.onChanged, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           Text(style: const TextStyle(fontWeight: FontWeight.bold),AppLocalizations.of(context)!.adminPrivileges),
          Switch(
            value: role == Role.admin ? true : false,
            onChanged: onChanged,
          ),
        ],
      ),
    ) ;
  }
}

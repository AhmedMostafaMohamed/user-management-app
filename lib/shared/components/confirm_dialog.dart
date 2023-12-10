import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child:  Text(AppLocalizations.of(context)!.confirm),
        ),
        TextButton(
          onPressed: onCancel,
          child:  Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }
}

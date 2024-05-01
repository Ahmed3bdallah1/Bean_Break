import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String actionName,
  void Function()? onPressed,
  bool? isOneChoice,
}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            body,
          ),
          actions: [
            isOneChoice != true
                ? const SizedBox()
                : CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('close')),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: onPressed,
                child: Text(actionName)),
          ],
        );
      });
}

import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(BuildContext context, String msg) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("확인"),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
  );
}
import 'package:flutter/material.dart';

class AlertModal {
  openModal(context, msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              msg,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
              softWrap: true,
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Fechar",
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

}

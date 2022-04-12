import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_projects/ui/usersList/views/users_list_screen.dart';

class PreviewScreen extends StatelessWidget {
  final File imageFile;
  // final List<File> fileList;

  const PreviewScreen({
    Key? key,
    required this.imageFile,
    // required this.fileList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UsersListScreen(),
                  ),
                );
              },
              child: const Text('Send and confirm'),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Image.file(imageFile),
          ),
        ],
      ),
    );
  }
}

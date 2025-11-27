import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Text('User Page $userId'),
      ),
    );
  }
}

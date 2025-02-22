import 'package:conversai/app/services/auth_services.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService(); // Using AuthService

  Future<void> _signOut() async {
    await _authService.signOutUser();
    Navigator.pushReplacementNamed(
        context, '/welcome'); // Navigate using named route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Home Screen'),
      ),
    );
  }
}

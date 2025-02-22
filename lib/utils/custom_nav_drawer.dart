import 'package:conversai/app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();
  final User? _user = FirebaseAuth.instance.currentUser;

  NavDrawer({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOutUser();
    Navigator.pushReplacementNamed(context, '/welcome'); // ✅ Using named route
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 45,
                ),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: const Text('New Call'),
                  onTap: () {
                    Navigator.pushNamed(context, '/call'); // ✅ Named route
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Messages'),
                  onTap: () {
                    Navigator.pushNamed(context, '/messages'); // ✅ Named route
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings'); // ✅ Named route
                  },
                ),
              ],
            ),
          ),

          // 🔹 Sign Out Button (Before Profile Section)
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _signOut(context),
          ),

          // 🔹 Profile Section (At the Bottom)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: _user?.photoURL != null
                      ? NetworkImage(_user!.photoURL!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.displayName ?? "User Name",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _user?.email ?? "email@example.com",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

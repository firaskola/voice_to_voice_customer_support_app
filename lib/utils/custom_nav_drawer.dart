import 'package:conversai/app/constants/constants.dart';
import 'package:conversai/app/helpers/cloud_firestore_helper.dart';
import 'package:conversai/app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final AuthService _authService = AuthService();
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirestoreHelper _firestoreHelper = FirestoreHelper();

  String _fullName = "User Name"; // Default placeholder

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if (_user == null) return;

    try {
      var userData = await _firestoreHelper.getUserData(_user!.uid);
      if (userData != null && userData.containsKey('full_name')) {
        setState(() {
          _fullName = userData['full_name'];
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOutUser();
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  Future<void> _startNewChat() async {
    if (_user == null) {
      print("User not logged in");
      return;
    }

    final chatId = await _firestoreHelper.createNewChat(_user!.uid);
    print("New chat created with ID: $chatId");
    Navigator.pushReplacementNamed(context, '/chat');
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
                Container(
                  color: kPrimaryColor,
                  height: 200,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.home, color: kPrimaryColor),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.message, color: kPrimaryColor),
                  title: const Text(
                    'New Chat',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/call');
                    await _startNewChat();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.history, color: kPrimaryColor),
                  title: const Text(
                    'History',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/history');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings, color: kPrimaryColor),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                const Divider(),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _signOut(context),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 32, top: 16, right: 16),
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
                      _fullName, // Updated to use fetched name
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      _user?.email ?? "email@example.com",
                      style: TextStyle(
                        fontSize: 14,
                        color: kPrimaryColor.withOpacity(0.7),
                      ),
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

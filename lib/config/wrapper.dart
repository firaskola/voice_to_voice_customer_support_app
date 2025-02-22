import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/routes/app_routes.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator())); // Loading screen
        } else if (snapshot.hasData) {
          // User is logged in, navigate to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          });
        } else {
          // No user, navigate to welcome screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.welcome);
          });
        }
        return const SizedBox(); // Empty widget before redirection
      },
    );
  }
}

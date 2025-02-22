
import 'package:conversai/veiws/call/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:conversai/veiws/auth/ForgotPassword/forgot_password_screen.dart';
import 'package:conversai/veiws/auth/Login/login_screen.dart';
import 'package:conversai/veiws/auth/Signup/signup_screen.dart';
import 'package:conversai/veiws/auth/Welcome/welcome_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
          fullscreenDialog: true, // Ensures it's treated as a fresh start
        );
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) =>  TapToTalkScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found!')),
          ),
        );
    }
  }
}

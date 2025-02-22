import 'package:conversai/utils/custom_text_feild.dart';
import 'package:conversai/utils/custom_widgets.dart';
import 'package:conversai/veiws/auth/components/already_have_an_account_acheck.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/constants.dart';

import '../../ForgotPassword/forgot_password_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: "Your Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: AppCustomWidgets.validateEmail,
          ),

          CustomTextField(
            hintText: "Your Password",
            icon: Icons.lock,
            obscureText: true,
            controller: _passwordController,
            validator: AppCustomWidgets.validatePassword,
          ),
          const SizedBox(height: 4), // Minimal gap before "Forgot Password?"
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Removes extra padding
                minimumSize: const Size(0, 0), // Ensures no extra spacing
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // Keeps it compact
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Implement login functionality
              }
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

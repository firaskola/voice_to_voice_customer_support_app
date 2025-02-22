import 'package:conversai/app/services/auth_services.dart';
import 'package:conversai/config/models/response_model.dart';
import 'package:conversai/utils/custom_text_feild.dart';
import 'package:conversai/utils/custom_widgets.dart';
import 'package:conversai/veiws/auth/components/already_have_an_account_acheck.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/constants/constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    AuthService authService = AuthService();
    ResponseModel response =
        await authService.signInUser(email: email, password: password);

    if (response.status) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }

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
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            onPressed: _submitForm,
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      ),
    );
  }
}

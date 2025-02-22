import 'package:conversai/utils/custom_text_feild.dart';
import 'package:conversai/utils/custom_widgets.dart';
import 'package:conversai/veiws/auth/components/already_have_an_account_acheck.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const CustomTextField(
            hintText: "Full Name",
            icon: Icons.person,
            keyboardType: TextInputType.name,
            validator: AppCustomWidgets.validateName,
          ),
          const CustomTextField(
            hintText: "Your Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: AppCustomWidgets.validateEmail,
          ),
          const CustomTextField(
            hintText: "Your Phone Number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: AppCustomWidgets.validatePhone,
          ),
          CustomTextField(
            hintText: "Your Password",
            icon: Icons.lock,
            obscureText: true,
            controller: _passwordController,
            validator: AppCustomWidgets.validatePassword,
          ),
          CustomTextField(
            hintText: "Confirm Password",
            icon: Icons.lock,
            obscureText: true,
            controller: _confirmPasswordController,
            validator: (value) => AppCustomWidgets.validateConfirmPassword(
              value,
              _passwordController.text,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                //Handle successful sign-up
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

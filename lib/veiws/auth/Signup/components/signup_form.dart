import 'package:conversai/app/services/auth_services.dart';
import 'package:conversai/config/models/response_model.dart';
import 'package:conversai/utils/custom_text_feild.dart';
import 'package:conversai/utils/custom_widgets.dart';
import 'package:conversai/veiws/auth/components/already_have_an_account_acheck.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/constants/constants.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    AuthService authService = AuthService();
    ResponseModel response = await authService.signUpUser(
      fullName: fullName,
      email: email,
      phoneNo: phone,
      password: password,
    );

    if (response.status) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      Navigator.pushReplacementNamed(context, '/login');
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
        children: [
          CustomTextField(
            hintText: "Full Name",
            icon: Icons.person,
            keyboardType: TextInputType.name,
            controller: _fullNameController,
            validator: AppCustomWidgets.validateName,
          ),
          CustomTextField(
            hintText: "Your Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: AppCustomWidgets.validateEmail,
          ),
          CustomTextField(
            hintText: "Your Phone Number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            controller: _phoneController,
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
            onPressed: _submitForm,
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              // Navigate to login using named route
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

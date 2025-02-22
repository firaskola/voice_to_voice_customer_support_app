import 'package:conversai/app/services/auth_services.dart';
import 'package:conversai/config/models/response_model.dart';
import 'package:conversai/utils/custom_text_feild.dart';
import 'package:conversai/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/constants/constants.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();
    AuthService authService = AuthService();

    ResponseModel response = await authService.resetPassword(email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message)),
    );

    if (response.status) {
      // Navigate to login page after showing success message
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: "Enter your email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: AppCustomWidgets.validateEmail,
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: _resetPassword,
            child: Text("Reset Password".toUpperCase()),
          ),
        ],
      ),
    );
  }
}

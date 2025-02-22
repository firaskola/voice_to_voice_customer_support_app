import 'package:conversai/utils/custom_text_feild.dart';
import 'package:conversai/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/constants.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                //Implement password reset functionality
              }
            },
            child: Text("Reset Password".toUpperCase()),
          ),
        ],
      ),
    );
  }
}

import 'package:conversai/app/responsive.dart';
import 'package:conversai/veiws/auth/components/background.dart';
import 'package:flutter/material.dart';

import 'components/forgot_password_form.dart';
import 'components/forgot_password_top_image.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileForgotPasswordScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: ForgotPasswordScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: ForgotPasswordForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileForgotPasswordScreen extends StatelessWidget {
  const MobileForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ForgotPasswordScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: ForgotPasswordForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

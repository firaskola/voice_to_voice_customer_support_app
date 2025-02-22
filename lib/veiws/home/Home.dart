import 'package:conversai/app/constants/constants.dart';
import 'package:conversai/utils/custom_nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
        title: const Text(
          'Home',
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      drawer: const NavDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: defaultPadding * 2),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: SvgPicture.asset("assets/icons/login.svg"),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: defaultPadding * 7),
          // Center the text and handle overflow
          const Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to ConversAI, your AI customer service assistant. ',
                  textAlign: TextAlign.center, // Center-align the text
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding * 2), // Add some spacing
          // Add an ElevatedButton
          Padding(
            padding: const EdgeInsets.only(left: 27.0, right: 27),
            child: ElevatedButton(
              onPressed: () {
                // Add your button's functionality here
                Navigator.pushReplacementNamed(context, '/call');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor, // Button background color
                foregroundColor: kPrimaryLightColor, // Button text color
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Get Started"),
            ),
          ),
        ],
      ),
    );
  }
}

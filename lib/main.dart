import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';

import 'package:project/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      print('Successfully configured');
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        // set the default theme
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            backgroundColor: Colors.white,
          ),
        ).copyWith(
          indicatorColor: Colors.red,
        ),
        // set the dark theme (optional)
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
          ),
        ),
        // set the theme mode to respond to the user's system preferences (optional)
        themeMode: ThemeMode.system,
        builder: Authenticator.builder(),
        home: const Scaffold(
          body: Center(
            child: Home(),
          ),
        ),
      ),
    );
  }
}

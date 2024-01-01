import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octasaur/Authentication/constants/custom_text_field.dart';
import 'package:octasaur/Authentication/constants/login_register_button.dart';
import 'package:octasaur/Authentication/firebase_auth/firebase_auth_services.dart';
import 'package:octasaur/Authentication/firebase_auth/is_valid_email.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final IsValidEmail _validEmail = IsValidEmail();

  void signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user =
        await _auth.signInWithEmailAndPassword(context, email, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("User successfully signed in"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    }
  }

  void signInWithGoogle() async {
    User? user = await _auth.signInWithGoogle(context);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("User successfully signed in"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            LoginRegisterButton(
                              text: 'Login',
                              onTap: () {
                                if (_signInFormKey.currentState!.validate()) {
                                  if (_validEmail.isInstituteEmail(
                                      _emailController.text)) {
                                    signInUser();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Please use institute email id'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            SignInButton(
                              Buttons.Google,
                              text: "Sign In with Google",
                              onPressed: () {
                                signInWithGoogle();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          // Navigate to the registration screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text('Don\'t have an account? Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

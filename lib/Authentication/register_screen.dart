import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octasaur/Authentication/constants/global_variables.dart';
import 'package:octasaur/Authentication/constants/google_button.dart';
import 'package:octasaur/Authentication/constants/login_register_button.dart';
import 'package:octasaur/Authentication/firebase_auth/firebase_auth_services.dart';
import 'package:octasaur/Authentication/firebase_auth/is_valid_email.dart';
import 'package:octasaur/Authentication/login_screen.dart';
import 'package:octasaur/home_screen.dart';
import 'constants/custom_text_field.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _collageNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final IsValidEmail _validEmail = IsValidEmail();

  void signUpUser() async {
    String username = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String instituteName = _collageNameController.text;

    User? user =
        await _auth.signUpWithEmailAndPassword(context, email, password);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("User is scucessfully created"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Registration failed"),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _collageNameController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Register',
        ),
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
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Name',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: _collageNameController,
                        hintText: 'Institute Name',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            LoginRegisterButton(
                              text: 'Register',
                              onTap: () {
                                if (_signUpFormKey.currentState!.validate()) {
                                  if (_validEmail.isInstituteEmail(
                                      _emailController.text)) {
                                    signUpUser();
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Already have an account? SignIn'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import'package:flutter/material.dart';
class LoginRegisterButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const LoginRegisterButton({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: onTap,
      child: Text(text, style: TextStyle(color: Colors.white),),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(),
        backgroundColor: Colors.black,
      )
    );
  }
}

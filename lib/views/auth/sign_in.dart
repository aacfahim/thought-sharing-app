import 'package:flutter/material.dart';
import 'package:social_media_app/views/auth/register.dart';
import 'package:social_media_app/views/helper/firebase_helpers.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(label: Text("Email")),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(label: Text("Password")),
          ),
          ElevatedButton(
              onPressed: () {
                var email = emailController.text;
                var password = passwordController.text;

                FirebaseHelpers()
                    .signInUsingEmailPassword(email, password, context);
              },
              child: Text("SIGN IN")),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("Not registered yet? Sign Up"))
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/views/auth/sign_in.dart';
import 'package:social_media_app/views/helper/firebase_helpers.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: InputDecoration(label: Text("Name")),
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(label: Text("Email")),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(label: Text("password")),
              ),
              ElevatedButton(
                  onPressed: () => FirebaseHelpers()
                      .signUp(name.text, email.text, password.text, context),
                  child: Text("Sign Up")),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Text("Already a user? Sign In"))
            ],
          ),
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/views/helper/firebase_helpers.dart';
import 'package:social_media_app/views/user/edit_profile.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final getCurrentUser = FirebaseHelpers().getCurrentUID();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
              child: CircleAvatar(
                radius: 100,
                backgroundImage: getCurrentUser!.photoURL == null
                    ? NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/149/149071.png")
                    : NetworkImage("${getCurrentUser!.photoURL}"),
              ),
            ),
            Text(
              "${getCurrentUser!.displayName}",
              style: TextStyle(fontSize: 35),
            ),
            Text("${getCurrentUser!.email}"),
            ElevatedButton(onPressed: () {}, child: Text("Edit"))
          ],
        ),
      ),
    );
  }
}

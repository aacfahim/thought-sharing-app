import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/views/user/add_post.dart';
import 'package:social_media_app/views/helper/firebase_helpers.dart';
import 'package:social_media_app/views/user/profile_info.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final getCurrentUser = FirebaseHelpers().getCurrentUID();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileInfo()),
                    ),
                child: Text("Profile")),
            ElevatedButton(
                onPressed: () => FirebaseHelpers().signOut(context),
                child: Text("Logout"))
          ],
        ) // Populate the Drawer in the next step.
            ),
      ),
      appBar: AppBar(
        title: Text("${getCurrentUser!.displayName}"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPost()),
            );
          },
          child: Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: getCurrentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('${data['profile-photo']}'),
                          ),
                          SizedBox(width: 10),
                          Text('${data['displayname']}')
                        ],
                      ),
                      Text('${data['post']}'),
                      ClipRRect(child: Image.network('${data['image']}')),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}

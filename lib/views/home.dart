import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/views/user/add_post.dart';
import 'package:social_media_app/views/helper/firebase_helpers.dart';
import 'package:social_media_app/views/user/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final getCurrentUser = FirebaseHelpers().getCurrentUID();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Feed"),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  ),
              child: Text("mypost")),
          IconButton(
              onPressed: () => FirebaseHelpers().signOut(context),
              icon: Icon(Icons.logout))
        ],
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
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
                          Text('${data['displayname']}',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      Text('${data['post']}'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ClipRRect(
                            child: Image.network(
                          '${data['image']}',
                          fit: BoxFit.cover,
                        )),
                      ),
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

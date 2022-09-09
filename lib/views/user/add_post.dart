import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/views/helper/firebase_helpers.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController descriptionController = TextEditingController();

  XFile? _itemPhoto;
  String? imageURl;
  chooseImage() async {
    ImagePicker picker = ImagePicker();
    _itemPhoto = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  addPost() async {
    File _itemPhotoFile = File(_itemPhoto!.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask uploadTask = storage
        .ref('post-photo')
        .child(_itemPhoto!.name)
        .putFile(_itemPhotoFile);

    TaskSnapshot snapshot = await uploadTask;
    imageURl = await snapshot.ref.getDownloadURL();

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('posts');

    collectionReference.add({
      'image': imageURl,
      'post': descriptionController.text,
      'uid': getCurrentUser!.uid,
      'displayname': getCurrentUser!.displayName,
      'profile-photo': getCurrentUser!.photoURL
    });
  }

  final getCurrentUser = FirebaseHelpers().getCurrentUID();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _itemPhoto == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  chooseImage();
                                },
                                icon: Icon(Icons.add_to_photos_rounded)),
                            Text("Add photo")
                          ],
                        )
                      : Image.file(File(_itemPhoto!.path)),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    label: Text("Write something about your thoughts"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      addPost();
                      Navigator.pop(context);
                    },
                    child: Text("Publish"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

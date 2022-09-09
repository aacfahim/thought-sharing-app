import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  XFile? _itemPhoto;
  String? imageURl;
  chooseImage() async {
    ImagePicker picker = ImagePicker();
    _itemPhoto = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  addProfilePic() async {
    File _itemPhotoFile = File(_itemPhoto!.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask uploadTask = storage
        .ref('profile-photo')
        .child(_itemPhoto!.name)
        .putFile(_itemPhotoFile);

    TaskSnapshot snapshot = await uploadTask;
    imageURl = await snapshot.ref.getDownloadURL();

    await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageURl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
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
                          Text("Add your picture")
                        ],
                      )
                    : Image.file(File(_itemPhoto!.path)),
              ),
              ElevatedButton(
                  onPressed: () {
                    addProfilePic();
                    Navigator.pop(context);
                  },
                  child: Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:core';
import 'dart:io' as io;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/OpenOrders.dart';
import 'package:untitled/ProflieModel.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'main.dart';
import 'package:untitled/NavBar.dart';
import 'package:clipboard/clipboard.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Proflie extends StatefulWidget {
  const Proflie({Key? key}) : super(key: key);

  @override
  _ProflieState createState() => _ProflieState();
}

class _ProflieState extends State<Proflie> {
  final _formKey = GlobalKey<FormState>();
  String? ph;
  ProflieModel? register;
  String? userDocId;
  @override
  void initState() {
    SharedPreferences sharedPreferences;
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      if (sp.containsKey(ProflieModel.ph_key)) {
        //in this case the app is already installed, so we need to get details of user
        ph = sp.getString(ProflieModel.ph_key);
        FirebaseFirestore.instance
            .collection('users')
            .where(ProflieModel.ph_key, isEqualTo: ph)
            .get()
            .then((value) {
          userDocId = value.docs[0].id;
          register = ProflieModel(
              phno: value.docs[0].data()[ProflieModel.ph_key],
              name: value.docs[0].data()[ProflieModel.ph_name],
              gender: value.docs[0].data()[ProflieModel.ph_gender],
              age: value.docs[0].data()[ProflieModel.ph_age],
              imgurl: value.docs[0].data()[ProflieModel.ph_img]);
          name.text = register!.name;
          age.text = register!.age;
        });
        /* Timer(Duration(seconds: 2),() => Get.to(ph!=null ?Proflie(): MyHomePage()));*/
      } else {}
      setState(() {});
    });
  }

  String? _downloadurl;
  final name = TextEditingController();
  final age = TextEditingController();
  final gender = TextEditingController();
  final imgurl = TextEditingController();
  final phno = TextEditingController();
  final myController = TextEditingController();

  String? fliename;
  String? tname;
  Future<void> insertData(final register) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("users")
        .add(register)
        .then((DocumentReference document) {
      print(document.id);
    }).catchError((e) {
      print(e);
    });
  }

  File? _image;
  ImagePicker imagePicker = ImagePicker();

  Future getImage() async {
    var image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 200,
        maxWidth: 200,
        imageQuality: 100);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_image!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);

    await Future.value(uploadTask);
    String url = (await ref.getDownloadURL()).toString();
    print(url);
    _downloadurl = url;
/*        .then((value) =>
    {

      print("Upload file path ${value.ref.fullPath}")

    }).onError((error, stackTrace) =>
    {
      print("Upload file path error ${error.toString()} ")
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Center(child: Text('Ecommerce notifications')),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      elevation: 4.0,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: (_image != null)
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage("assets/images/proflie.png"),
                              /* image: NetworkImage('https://avatars.githubusercontent.com/u/86800136?s=20&v=4'),*/
                              /*fit: BoxFit.none,
                          width: 80.0,
                          height: 80.0,*/
                              child: InkWell(
                                onTap: () {
                                  getImage();
                                },
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      UserFullName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      phoneNumberVerified,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: 300,
                                margin: EdgeInsets.only(right: 3),
                                height: 190,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        compName,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        compAddress,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Row(
                                        children:[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(200, 0 , 0, 0),
                                            child: IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.file,
                                              ),
                                              iconSize: 25,
                                              color: Colors.blue,
                                              onPressed: () {
                                                FlutterClipboard.copy(compAddress).then(
                                                        (value) => ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "copy to clipboard",
                                                            textAlign:
                                                            TextAlign
                                                                .center),
                                                        backgroundColor:
                                                        Colors
                                                            .indigoAccent,
                                                        padding:
                                                        EdgeInsets.all(
                                                            20),
                                                        shape:
                                                        StadiumBorder())));
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),

                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}


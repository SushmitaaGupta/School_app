import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';


class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}


class _profileState extends State<profile> {

  File? image;
  Future fromGallary() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,);

      if (image == null) return;
      final imagefile = File(image.path);
      setState(() {
      });(() {
        this.image = imagefile;
      });
    } on PlatformException catch (e) {
      print("Failed to load image: $e");
    }
  }
  Future fromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,);

      if (image == null) return;
      final imagefile = File(image.path);
      setState(() {
      });(() {
        this.image = imagefile;
      });
    } on PlatformException catch (e) {
      print("Failed to load image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                image != null ? ClipOval(child: Image.file(
                  image!,
                  fit: BoxFit.cover,)):
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: (){

                          },

                        ),
                      ),
                      radius: 55.0,
                      backgroundImage: const AssetImage("assets/man.png"),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: const Text('sachin bhagat', style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: const Text('sachinbhagat767@gmail.com', style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0,
                    ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: const Text(
                      'Software Developers',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextButton(
                      onPressed: () {
                      },
                      child: InkWell(onTap: (){
                        option(context );
                      }
                        ,
                        child: Container(
                          padding:
                          const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          decoration: const BoxDecoration(
                            color: Color(0xff328582),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),

        ],
      ),
    );
  }
  option(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true, context: context, builder: (BuildContext c) {
      return Wrap(
        children: [
          Column(
            children: [

              Row( mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 15, bottom: 10),
                    child: Text("Select Your Choice"),
                  ),
                ],
              ),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>( Colors.white),
                      elevation: MaterialStateProperty.all(10)
                    ),

                    onPressed: () {
                      fromCamera();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row( mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt_outlined, color: Color(0xff26a69a),),
                          SizedBox(width: 10,),
                          Text("Open Camera", style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff26a69a)),),
                        ],
                      ),
                    ),),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all(10),
                    ),

                    onPressed: () {
                      fromGallary();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row( mainAxisAlignment:MainAxisAlignment.center ,
                        children: const [
                          Icon(Icons.photo_size_select_actual_outlined,color: Color(0xff26a69a),),
                          SizedBox(width: 10,),
                          Text("Open Gallery", style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff26a69a)),),
                        ],
                      ),
                    ),),
                ],
              ),
            ],
          ),
        ],
      );
    }
    );
  }
}

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


extension StringExtension on String {
String capitalize() {
  return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
}
}


class studentProfile extends StatefulWidget {
  const studentProfile ({Key? key}) : super(key: key);

  @override
  State<studentProfile > createState() => studentProfileState();
}
List jsonResponse=[];

class Student_Profile_detail {
  String studentProfileImgPath;
  String name;
  String emailId;
  String phone1;
  String schoolId;
  String sectionId;
  String classId;
  String sectionName;
  String className;
  String age;
  String dob;
  String schoolName;
  String address;
  String guardianName;
  String guardianProfileImgPath;
  String phone2;
  String guardianPancard;
  String guardianAadhar;




  Student_Profile_detail({
    required this.studentProfileImgPath,
    required this.name,
    required this.emailId,
    required this.phone1,
    required this.schoolId,
    required this.sectionId,
    required this.classId,
    required this.sectionName,
    required this.className,
    required this.age,
    required this.dob,
    required this.schoolName,
    required this.address,
    required this.guardianName,
    required this.guardianProfileImgPath,
    required this.phone2,
    required this.guardianAadhar,
    required this.guardianPancard,
  });

  factory Student_Profile_detail.fromJson(Map<String, dynamic> json) {
    return Student_Profile_detail(
      studentProfileImgPath: json['studentProfileImgPath'],
      name: json['name'],
      emailId: json['emailId'],
      phone1: json['phone1'],
      schoolId: json['schoolId'],
      sectionId: json['sectionId'],
      classId: json['classId'],
      sectionName: json['sectionName'],
      className: json['className'],
      age: json['age'],
      dob: json['dob'],
      schoolName: json['schoolName'],
      address: json['address'],
      guardianName: json['guardianName'],
      guardianProfileImgPath: json['guardianProfileImgPath'],
      phone2: json['phone2'],
      guardianPancard: json['guardianPancard'],
      guardianAadhar: json['guardianAadhar'],

    );
  }
}

Future<List<Student_Profile_detail>> Student_Profile_detail_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  var url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/studentDetail";
  Map mapdata = {
    "student_id":sf.getString("studentid").toString(),
  };
  http.Response response = await http.post(Uri.parse(url), body: mapdata);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['studentList'];

    return jsonResponse.map((data) => Student_Profile_detail.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}




class studentProfileState extends State<studentProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
        gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              FutureBuilder<List<Student_Profile_detail>>(
                  future: Student_Profile_detail_API(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Student_Profile_detail>? data = snapshot.data;

                    return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [

                      SizedBox(height:20),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:8),
                    child: Text("Student Details",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize:17),),
                    ),

                    Divider(color:Colors.black),

                    Container(
                    width:MediaQuery.of(context).size.width,
                    child : Padding(
                    padding:EdgeInsets.only(left:5,right:5),
                    child : Card(
                    color:Color(0xffE2D1C3),
                    elevation:20,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                    Radius.circular(5),)),
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                    Padding(
                    padding: EdgeInsets.all(8.0),
                    child : CircleAvatar(
                    radius: 30,
                    backgroundImage:
                    NetworkImage("http://103.148.157.74:33178/DigiSchoolWebAppNew/${data![0].studentProfileImgPath.toString()}",),
                    ),),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Name : " + data[0].name.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Age : " + data[0].age.toString().capitalize() + " years",style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Birthdate : " + data[0].dob.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("School : " + data[0].schoolName.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Class : " + data[0].className.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Section : " + data[0].sectionName.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Address : " + data[0].address.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    SizedBox(height:10),

                    ],
                    ),),),),


                    SizedBox(height:20),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:8),
                    child: Text("Guardian Details",style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize:17),),
                    ),

                    Divider(color:Colors.black),

                    Container(
                    width:MediaQuery.of(context).size.width,
                    child : Padding(
                    padding:EdgeInsets.only(left:5,right:5),
                    child : Card(
                    color:Color(0xffE2D1C3),
                    elevation:20,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                    Radius.circular(5),)),
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                    Padding(
                    padding: EdgeInsets.all(8.0),
                    child : CircleAvatar(
                    radius: 30,
                    backgroundImage:
                    NetworkImage("http://103.148.157.74:33178/DigiSchoolWebAppNew/${data[0].guardianProfileImgPath.toString()}",),
                    ),),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Guardian Name : " + data[0].guardianName.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),


                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Email : " + data[0].emailId.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),



                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Primary number : " + data[0].phone1.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Alternate number : " + data[0].phone2.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),
                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Pan card no. : " + data[0].guardianPancard.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:0,left:18,bottom:5),
                    child: Text("Adhaar card no. : " + data[0].guardianAadhar.toString().capitalize(),style: TextStyle(color: Colors.amber.shade900,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),



                    SizedBox(height:10),

                    ],
                    ),),),),


                    ]

                    );
                    } else {
                    return Container();

                    }
                  }),
              SizedBox(height: 5,),





            ],
          ),
        ),
      ),
    );
  }
}
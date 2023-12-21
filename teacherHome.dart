import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'TeacherNotice.dart';
import 'attendance.dart';
import 'attendancenew.dart';

List jsonResponse =[];
String? Tname;

class GetStudentDetail {
  String guardianProfileImgName;
  String gender;
  String phone2;
  String className;
  String emailId;
  String phone1;
  String studentId;
  String sectionName;
  String classId;
  String guardianName;
  String schoolId;
  String registrationId;
  String schoolName;
  String pincode;
  String guardianPancard;
  String address;
  String studentProfileImgPath;
  String guardianProfileImgPath;
  String registerOn;
  String sectionId;
  String guardianAadhar;
  String dob;
  String name;
  String age;
  String studentProfileImgName;
  String secstatustionId;

  GetStudentDetail(
      {required this.guardianProfileImgName,
        required this.gender,
        required this.phone2,
        required this.className,
        required this.emailId,
        required this.phone1,
        required this.studentId,
        required this.sectionName,
        required this.classId,
        required this.guardianName,
        required this.schoolId,
        required this.registrationId,
        required this.schoolName,
        required this.pincode,
        required this.guardianPancard,
        required this.address,
        required this.studentProfileImgPath,
        required this.guardianProfileImgPath,
        required this.registerOn,
        required this.sectionId,
        required this.guardianAadhar,
        required this.dob,
        required this.name,
        required this.age,
        required this.studentProfileImgName,
        required this.secstatustionId,

      });

  factory GetStudentDetail.fromJson(Map<String, dynamic> json) {
    return GetStudentDetail(
      guardianProfileImgName: json['guardianProfileImgName'],
      gender: json['gender'],
      phone2: json['phone2'],
      className: json['className'],
      emailId: json['emailId'],
      phone1: json['phone1'],
      studentId: json['studentId'],
      sectionName: json['sectionName'],
      classId: json['classId'],
      guardianName: json['guardianName'],
      schoolId: json['schoolId'],
      registrationId: json['registrationId'],
      schoolName: json['schoolName'],
      pincode: json['pincode'],
      guardianPancard: json['guardianPancard'],
      address: json['address'],
      studentProfileImgPath: json['studentProfileImgPath'],
      guardianProfileImgPath: json['guardianProfileImgPath'],
      registerOn: json['registerOn'],
      sectionId: json['sectionId'],
      guardianAadhar: json['guardianAadhar'],
      dob: json['dob'],
      name: json['name'],
      age: json['age'],
      studentProfileImgName: json['studentProfileImgName'],
      secstatustionId: json['secstatustionId'],

    );
  }
}
class today_quotes {
  String schoolId;
  String quoteId;
  String quotes;

  today_quotes({
    required this.schoolId,
    required this.quoteId,
    required this.quotes,

  });

  factory today_quotes.fromJson(Map<String, dynamic> json) {
    return today_quotes(
      schoolId: json['schoolId'],
      quoteId: json['quoteId'],
      quotes: json['quotes'],

    );
  }
}

 TeacherName()async {
  SharedPreferences sf = await SharedPreferences.getInstance();
   Tname = sf.getString("Tname").toString();
   print("raajjj");
   print(sf.getString("Tname"));

}

Future<List<today_quotes>> today_quotes_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  var url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/quotesDetailApi/get_today_quotes";
  Map mapdata = {
    "school_id": sf.getString("TSchoolid").toString()
  };
  http.Response response = await http.post(Uri.parse(url),body: mapdata);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body)["quoteList"];
    print("Quotes");
    print(jsonResponse);
    return jsonResponse.map((data) => today_quotes.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}

Future<List<GetStudentDetail>> GetStudentDetail_API() async {

  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/studentDetailAsPerSection";
  return http.post(Uri.parse(myurl), body: {
    'class_id':"CLASS_40C462080600",
    'section_id':"SECTION_9B7D36B2283C",
    'school_id':"SCHOOL_77AB0A51BBFF"

  }).then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['studentList'];
      print(jsonResponse);
      return jsonResponse.map((data) => GetStudentDetail.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}


class teacherHome extends StatefulWidget {
  const teacherHome({Key? key}) : super(key: key);

  @override
  State<teacherHome> createState() => _teacherHomeState();
}

class _teacherHomeState extends State<teacherHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TeacherName();
  }

  @override
  Widget build(BuildContext context) {

    return  Container(
      decoration: const BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
        gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:SingleChildScrollView(
          child:  Column(
            children: [
              SizedBox(height: 5,),
             /* Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 8, bottom: 2),
                child: Row(
                  children: [
                    Text("Good Morning", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 25),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Text(Tname.toString()),
                  ],
                ),
              ),*/
              FutureBuilder<List<today_quotes>>(
                  future: today_quotes_API(),
                  builder: (context, snapshot) {
                    print("TEXT");
                    List<today_quotes>? data = snapshot.data;
                    print(data);
                    if (snapshot.hasData) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff0B6E4F),
                                  Colors.grey.shade400,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, top: 8.0,),
                                child: Row(
                                  children: [
                                    Text("Quote of the day!", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(jsonResponse[0]['quotes'].toString(),style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return  Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 0),
                        child:Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff0B6E4F),
                                    Colors.grey.shade400,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0, top: 8.0,),
                                  child: Row(
                                    children: [
                                      Text("Quote of the day!", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("A good education can change anyone, A good teacher can change everything",style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),

              Row(
                children: [
                  SizedBox (
                    width: 200,
                    height: 160,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherAttendenceNew()));
                      },
                      child: Card (
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        margin: EdgeInsets.all(10),
                        color: Colors.pink[900],
                        shadowColor: Colors.grey,
                        elevation: 10,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding:  EdgeInsets.only(top: 30.0),
                              child:
                              Column(
                                children: [
                                  Icon (
                                      Icons.note_alt,
                                      color: Colors.white,
                                      size: 30
                                  ),
                                  SizedBox(height: 10,),
                                  Text(" Student Attendence",
                                    style: TextStyle(fontSize: 18,color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox (
                    width: 200,
                    height: 160,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TeachernoticeBord()));
                      },
                      child: Card (
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        margin: EdgeInsets.all(10),
                        color: Colors.green[800],
                        shadowColor: Colors.grey,
                        elevation: 10,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:  Column(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(top: 25.0),
                                    child: Icon (
                                        Icons.note_add,
                                        color: Colors.white,
                                        size: 30
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Notice Board', style: TextStyle(fontSize: 18,color: Colors.white),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox (
                    width: 200,
                    height: 160,
                    child: Card (
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      margin: EdgeInsets.all(10),
                      color: Colors.teal[800],
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:  Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Icon (
                                      Icons.book,
                                      color: Colors.white,
                                      size: 30
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "Calender",
                                  style: TextStyle(fontSize: 18, color: Colors.white),)
                              ],
                            ),



                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox (
                    width: 200,
                    height: 160,
                    child: Card (
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      margin: EdgeInsets.all(10),
                      color: Colors.deepOrange[900],
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:  Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Icon (
                                      Icons.quiz,
                                      color: Colors.white,
                                      size: 30
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "Online Assignment",
                                  style: TextStyle(fontSize: 18, color: Colors.white),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox (
                    width: 200,
                    height: 160,
                    child: Card (
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      margin: EdgeInsets.all(10),
                      color: Colors.brown[700],
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:  Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Icon (
                                      Icons.book,
                                      color: Colors.white,
                                      size: 30
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "Daily Activity",
                                  style: TextStyle(fontSize: 18, color: Colors.white),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox (
                    width: 200,
                    height: 160,
                    child: Card (
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      margin: EdgeInsets.all(10),
                      color: Colors.cyan[700],
                      shadowColor: Colors.blueGrey,
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child:  Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Icon (
                                      Icons.menu_book,
                                      color: Colors.white,
                                      size: 30
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "Assignment",
                                  style: TextStyle(fontSize: 18, color: Colors.white),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
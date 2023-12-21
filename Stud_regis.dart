import 'dart:convert';
import 'dart:io';

import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mydigischool/Login_&_Register/Login_Con.dart';
import 'package:mydigischool/Login_&_Register/Login_student_page.dart';
import 'package:http/http.dart' as http;


List<PlatformFile> files = [];
void openFiles(List<PlatformFile> files) {
  //show(files: files);
}

class Stud_regis extends StatefulWidget {
  const Stud_regis({Key? key}) : super(key: key);
  @override
  State<Stud_regis> createState() => _Stud_regisState();
}
final _controller = PageController(initialPage: 0,);
DateTime selectedDate = DateTime.now();
TextEditingController First_Name = TextEditingController();
TextEditingController Admission_ID = TextEditingController();
TextEditingController Mobile_Num = TextEditingController();
TextEditingController P_Mobile_Num = TextEditingController();
TextEditingController Email_ID = TextEditingController();
TextEditingController Father_Name = TextEditingController();
TextEditingController Age = TextEditingController();
TextEditingController Class = TextEditingController();
TextEditingController Section = TextEditingController();
TextEditingController dateInput = TextEditingController();
TextEditingController Aadhar_no = TextEditingController();
TextEditingController Pancard_no = TextEditingController();
TextEditingController Address = TextEditingController();
TextEditingController Pin_Code = TextEditingController();
String? schoolname;
String? division;
String? section;
String? gender;
final formGlobalKey = GlobalKey<FormState>();
final formGlobalKey1 = GlobalKey<FormState>();
final formGlobalKey2 = GlobalKey<FormState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
ImagePicker imagePicker = ImagePicker();
String? Student_img;
String? Parent_img;
String? getschoolid;
String? getclassid;
String? schoolvalue;
String? classvalue;
String? sectionvalue;
String? filename;
String? Filestore;





class GetSchoolData {
  String pincode;
  String address;
  String schoolId;
  String schoolName;
  String status;

  GetSchoolData(
      {required this.pincode,
        required this.address,
        required this.schoolId,
        required this.schoolName,
        required this.status
      });

  factory GetSchoolData.fromJson(Map<String, dynamic> json) {
    return GetSchoolData(
      pincode: json['pincode'],
      address: json['address'],
      schoolId: json['schoolId'],
      schoolName: json['schoolName'],
      status: json['status'],);
  }
}

class GetClassData {
  String classId;
  String schoolId;
  String className;


  GetClassData(
      {required this.classId,
        required this.schoolId,
        required this.className,

      });

  factory GetClassData.fromJson(Map<String, dynamic> json) {
    return GetClassData(
      classId: json['classId'],
      schoolId: json['schoolId'],
      className: json['className'],
    );
  }
}

class GetSectionData {
  String sectionName;
  String classId;
  String schoolId;
  String sectionId;


  GetSectionData(
      {
        required this.sectionName,
        required this.classId,
        required this.schoolId,
        required this.sectionId,

      });

  factory GetSectionData.fromJson(Map<String, dynamic> json) {
    return GetSectionData(
      sectionName: json['sectionName'],
      classId: json['classId'],
      schoolId: json['schoolId'],
      sectionId: json['sectionId'],
    );
  }
}

Future<List<GetSchoolData>> GetSchools() async {
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/get_school_detail";
  return http.get(Uri.parse(myurl)).then((response) {
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['schoolList'];

      return jsonResponse.map((data) => GetSchoolData.fromJson(data)).toList();

    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}

Future<List<GetClassData>> getAllClasses(String schoolid) async {

  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/class_detail";
  return http.post(Uri.parse(myurl), body: {
    "school_id": schoolid,

  }).then((response) {
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['classList'];

      return jsonResponse.map((data) => GetClassData.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}

Future<List<GetSectionData>> getAllSections(String classid) async {
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/section_detail";
  return http.post(Uri.parse(myurl), body: {
    "class_id": classid,

  }).then((response) {
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['sectionList'];

      return jsonResponse.map((data) => GetSectionData.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}


void clearfile() {
  First_Name.clear();
  Admission_ID.clear();
  Mobile_Num.clear();
  P_Mobile_Num.clear();
  Email_ID.clear();
  Father_Name.clear();
  Age.clear();
  Class.clear();
  Section.clear();
  dateInput.clear();
  Aadhar_no.clear();
  Pancard_no.clear();
  Address.clear();
  Pin_Code.clear();
}



class _Stud_regisState extends State<Stud_regis> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(_controller);
    _controller;


  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/back.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create Your Account", style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18,),)
                ],),
              SizedBox(height: 5,),
              Text("Please Enter your information to create account "),
              /////Forms Starts From here......//////////
              Form(
                key: formGlobalKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                            controller: First_Name,
                            validator: (firstName) {
                              if ((firstName)!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Enter valid Name';
                              }
                            },
                            style: TextStyle(color: Colors.black,),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(Icons.person,
                                  color: Colors.deepOrangeAccent,),
                                hintText: "Enter Your Full Name",
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(
                                      color: Colors.deepOrangeAccent),
                                  borderRadius:  BorderRadius.all(
                                      Radius.circular(25)),),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)
                                )
                            )
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                      child: TextFormField(
                          controller: Admission_ID,
                          validator: (admissionId) {
                            if ((admissionId)!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Please Enter Admission_Id';
                            }
                          },
                          style: TextStyle(color: Colors.black,),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.school, color: Colors.deepOrangeAccent,),
                              hintText: "Admission ID",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.deepOrangeAccent),
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                      child: TextFormField(
                          controller: Mobile_Num,
                          validator: (Mobilenumber) {
                            if ((Mobilenumber)!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Please Enter Mobile Number';
                            }
                          },
                          style: TextStyle(color: Colors.black,),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.phone, color: Colors.deepOrangeAccent,),
                              hintText: "Mobile number",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.deepOrangeAccent),
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          )
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                      child: TextFormField(
                          controller: P_Mobile_Num,
                          validator: (Mobile_Num) {
                            if ((Mobile_Num)!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Please Enter Mobile Number';
                            }
                          },
                          style: TextStyle(color: Colors.black,),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.phone, color: Colors.deepOrangeAccent,),
                              hintText: "Parents Mobile number",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.deepOrangeAccent),
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          )
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                      child: TextFormField(
                          controller: Email_ID,
                          validator: (emailId) {
                            if ((emailId)!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Please Enter Valid Email_Id';
                            }
                          },
                          style: TextStyle(color: Colors.black,),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.mail, color: Colors.deepOrangeAccent,),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.deepOrangeAccent),
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                      child: TextFormField(
                          controller: Father_Name,
                          validator: (fatherName) {
                            if ((fatherName)!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Please Enter Guardian_Name';
                            }
                          },
                          style: TextStyle(color: Colors.black,),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.person, color: Colors.deepOrangeAccent,),
                              hintText: "Guardian Name",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.deepOrangeAccent),
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                      child: TextFormField(
                          controller: Age,
                          validator: (age) {
                            if ((age)!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Enter The Your age';
                            }
                          },
                          style: TextStyle(color: Colors.black,),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(
                                Icons.person, color: Colors.deepOrangeAccent,),
                              hintText: "Enter Age",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.deepOrangeAccent),
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          )
                      ),
                    ),

                    ///next button...///
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, top: MediaQuery
                          .of(context)
                          .size
                          .height / 14),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                if (formGlobalKey.currentState!.validate()) {
                                  formGlobalKey.currentState!.save();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Stud_regis1()));

                                  // use the email provided here
                                }
                              },
                              child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(color: Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "Next", style: TextStyle(color: Colors
                                          .white),),
                                    ),
                                  )))
                        ],),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Stud_regis1 extends StatefulWidget {
  const Stud_regis1({super.key});

  @override
  State<Stud_regis1> createState() => _Stud_regis1State();
}

class _Stud_regis1State extends State<Stud_regis1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/back.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create Your Account", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, ),)
                ],),
              SizedBox(height: 5,),
              Text("Please Enter your information to create account "),
              /////Forms Starts From here......//////////
              Form(
                key: formGlobalKey1,
                child: Column(
                  children: [
                    FutureBuilder<List<GetSchoolData>>(
                        future: GetSchools(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 12),
                              child: Container(
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0,
                                      style: BorderStyle.solid
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(left: 12.0),
                                            child: Icon(
                                              Icons.school,
                                              size: 25,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 12.0),
                                              child: Text(
                                                "Select School",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.deepOrangeAccent,
                                                ),

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      iconEnabledColor: Colors.deepOrangeAccent,
                                      iconDisabledColor: Colors.deepOrangeAccent,
                                      items: snapshot.data
                                          ?.map(
                                              (item) => DropdownMenuItem<String>(
                                            value: item.schoolId,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 14.0),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.school,
                                                    size: 25,
                                                    color: Colors.deepOrangeAccent,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    item.schoolName,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors.deepOrangeAccent,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                          .toList(),
                                      value: schoolvalue,
                                      onChanged: (value) {
                                        setState(() {
                                          schoolvalue = value as String;
                                          classvalue = null;

                                          //getAllClasses(schoolvalue.toString());
                                          print(schoolvalue);
                                        });
                                      },

                                    ),
                                  ),
                                ),
                              ),

                            );
                          }
                          return CircularProgressIndicator();
                        }
                    ),
                    schoolvalue != null ? FutureBuilder<List<GetClassData>>(
                        future: getAllClasses(schoolvalue.toString()),
                        builder: (context, snapshot) {
                          if(snapshot.hasData && snapshot.data!.length > 0){
                            print("This is working");
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 12),
                              child: Container(
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0,
                                      style: BorderStyle.solid
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(left: 14.0),
                                            child: Icon(
                                              Icons.class_,
                                              size: 25,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              "Select Class",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      iconEnabledColor: Colors.deepOrangeAccent,
                                      iconDisabledColor: Colors.deepOrangeAccent,
                                      items: snapshot.data
                                          ?.map(
                                              (item) => DropdownMenuItem<String>(
                                            value: item.classId,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 14.0),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.class_,
                                                    size: 25,
                                                    color: Colors.deepOrangeAccent,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    item.className,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Colors.deepOrangeAccent,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                          .toList(),
                                      value: classvalue,
                                      onChanged: (value) {
                                        setState(() {
                                          classvalue = value as String;
                                          sectionvalue = null;

                                        });
                                      },

                                    ),
                                  ),
                                ),
                              ),

                            );
                          }
                          else{
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 12),
                              child: Container(
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0,
                                      style: BorderStyle.solid
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(left: 0.0),
                                            child: Icon(
                                              Icons.class_,
                                              size: 25,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              "Select Class",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: []
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        }
                    )
                        :Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10, top: 12),
                      child: Container(
                        decoration:  BoxDecoration(
                          border: Border.all(
                              color: Colors.deepOrangeAccent,
                              width: 1.0,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Icon(
                                      Icons.class_,
                                      size: 25,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Text(
                                      "Select Class",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: []
                          ),
                        ),
                      ),
                    ),
                    classvalue != null && schoolvalue != null ? FutureBuilder<List<GetSectionData>>(
                        future: getAllSections(classvalue.toString()),
                        builder: (context, snapshot) {

                          if(snapshot.hasData && snapshot.data!.length > 0){
                            print("This is working");
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 12),
                              child: Container(
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0,
                                      style: BorderStyle.solid
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(left:14.0),
                                            child: Icon(
                                              Icons.class_,
                                              size: 25,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              "Select Section",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      iconEnabledColor: Colors.deepOrangeAccent,
                                      iconDisabledColor: Colors.deepOrangeAccent,
                                      items: snapshot.data!.length > 0 ? snapshot.data
                                          ?.map(
                                              (item) => DropdownMenuItem<String>(
                                            value: item.sectionId,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.class_,
                                                  size: 25,
                                                  color: Colors.deepOrangeAccent,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  item.sectionName,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.deepOrangeAccent,
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ],
                                            ),
                                          ))
                                          .toList():[],
                                      value: sectionvalue,
                                      onChanged: (value) {

                                        setState(() {

                                          sectionvalue = value as String;
                                          print(sectionvalue);
                                        });
                                      },

                                    ),
                                  ),
                                ),
                              ),
                            );
                          }else{
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10, top: 12),
                              child: Container(
                                decoration:  BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0,
                                      style: BorderStyle.solid
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(left: 14.0),
                                            child: Icon(
                                              Icons.class_,
                                              size: 25,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              "Select Section",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),

                                      items: []
                                  ),
                                ),
                              ),
                            );
                          }return Container();
                        }
                    )
                        :Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10, top: 12),
                      child: Container(
                        decoration:  BoxDecoration(
                          border: Border.all(
                              color: Colors.deepOrangeAccent,
                              width: 1.0,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  const Icon(
                                    Icons.class_,
                                    size: 25,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Select Section",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: []
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: dateInput,
                            validator:(dateInput) {
                              if ((dateInput)!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Select Date in Dropdown';
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                                borderRadius:new BorderRadius.all(Radius.circular(25)),),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              ),
                              contentPadding:EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0) ,
                              fillColor: Colors.white,
                              hintText: "Enter Date Of Birth",hintStyle: TextStyle(color: Colors.black54),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.calendar_today,color: Colors.deepOrangeAccent
                                ),
                              ),
                            ),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary:Color(0xFF6F35A5), // <-- SEE HERE
                                          onPrimary: Colors.white, // <-- SEE HERE
                                          onSurface: Colors.black, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                            Colors.white, // button text color
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  });
                              if (pickedDate != null) {
                                print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  dateInput.text = formattedDate;//set output date to TextField value.

                                });
                              }
                              else{}
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                            controller: Aadhar_no,
                            validator: (Aadhar) {
                              if ((Aadhar)!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Enter valid Name';
                              }
                            },
                            style: TextStyle(color: Colors.black,),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                hintText: "Enter Your Guardian Aadhaar No",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                                  borderRadius:new BorderRadius.all(Radius.circular(25)),),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                            controller: Pancard_no,
                            validator: (Pancard) {
                              if ((Pancard)!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Enter valid Name';
                              }
                            },
                            style: TextStyle(color: Colors.black,),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                hintText: "Enter Your Guardian Pan-card No",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                                  borderRadius:new BorderRadius.all(Radius.circular(25)),),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)
                                )
                            )
                        )
                    ),
                    ///next button...///
                    Padding(
                      padding:  EdgeInsets.only(right: 20.0,top: MediaQuery.of(context).size.height/7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Stud_regis()));
                              },
                              child:Container(
                                  width: 100,
                                  padding: EdgeInsets.only(right: 0,left: 15,top: 7,bottom: 7),
                                  decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_back,color: Colors.white,),
                                      SizedBox(width: 3,),
                                      Text("Back",style: TextStyle(color: Colors.white),),
                                    ],
                                  ))
                          ),

                          InkWell(
                              onTap: (){
                                if (formGlobalKey.currentState!.validate()) {
                                  formGlobalKey.currentState!.save();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Stud_regis2()));
                                  //; use the email provided here
                                }
                              },
                              child:Container(
                                  width: 100,
                                  decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text("Next",style: TextStyle(color: Colors.white),),
                                    ),
                                  )))
                        ],),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Stud_regis2 extends StatefulWidget {
  const Stud_regis2({super.key});

  @override
  State<Stud_regis2> createState() => _Stud_regis2State();
}

class _Stud_regis2State extends State<Stud_regis2> {

  Future studentregi() async {
    var request = http.MultipartRequest('POST', Uri.parse("http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/saveDetail"));
    request.fields['student_name']=First_Name.text;
    request.fields['phone1'] = Mobile_Num.text;
    request.fields['phone2'] = P_Mobile_Num.text;
    request.fields['guardian_email'] =  Email_ID.text;
    request.fields['guardian_name'] = Father_Name.text;
    request.fields['gender'] = gender.toString();
    request.fields['dob'] = dateInput.text  ;
    request.fields['age'] = Age.text;
    request.fields['school_id'] =schoolvalue.toString();
    request.fields['class_id']=classvalue.toString();
    request.fields['section_id']= sectionvalue.toString();
    request.fields['admission_id']=Admission_ID.text;
    request.fields['guardian_aadhar_no'] = Aadhar_no.text;
    request.fields['guardian_pan_no'] = Pancard_no.text;
    request.fields['address'] = Address.text;
    request.fields['pincode'] = Pin_Code.text;
    request.files.add(await http.MultipartFile.fromPath('student_profile_img', Student_img.toString()));
    request.files.add(await http.MultipartFile.fromPath('birth_certificate', Filestore.toString()));
    request.files.add(await http.MultipartFile.fromPath('guardian_profile_img',Parent_img.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print(response.stream);
      const snackBar = SnackBar(
        content: Text('Your register is Successful'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Con()));
      clearfile();
      return true;
    } else {
      print("Something Went Wrong");
      const snackBar = SnackBar(
        content: Text('Something Went Wrong'),
      );
      // print(response.reasonPhrase);
      return false;
    }
  }

  File? image;
//////// Here i've created Function To fetch the value from Gallary...........
  Future fromGallary() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,);

      if (image == null) return;
      final imagefile = File(image.path);
      setState(() {
        this.image = imagefile;

        Student_img=this.image!.path;

      });
    } on PlatformException catch (e) {
      print("Failed to load image: $e");
    }
  }
////////////This Is the function to fetched Piture from Camera...................
  Future fromcamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,);
      if (image == null) return;
      final imagefile = File(image.path);
      setState(() {
        this.image = imagefile;
        Student_img=this.image!.path;
      });
    } on PlatformException catch (e) {
      print("Failed to load image: $e");
    }
  }

  File? image1;
//////// Here i've created Function To fetch the value from Gallary...........
  Future fromGallary1() async {
    try {
      final image1 = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,);

      if (image1 == null) return;
      final imagefile = File(image1.path);
      setState(() {
        this.image1 = imagefile;
        Parent_img=this.image1!.path;
      });
    } on PlatformException catch (e) {
      print("Failed to load image: $e");
    }
  }
////////////This Is the function to fetched Piture from Camera...................
  Future fromcamera1() async {
    try {
      final image1 = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,);
      if (image1 == null) return;
      final imagefile = File(image1.path);
      setState(() {
        this.image1 = imagefile;
        Parent_img=this.image1!.path;
      });
    } on PlatformException catch (e) {
      print("Failed to load image: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/back.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Create Your Account", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, ),)
                ],),
              SizedBox(height: 5,),
              Text("Please Enter your information to create account "),
              /////Forms Starts From here......//////////
              Form(
                key: formGlobalKey2,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                            controller: Address,
                            validator: (address) {
                              if ((address)!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Enter valid Name';
                              }
                            },
                            style: TextStyle(color: Colors.black,),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                hintText: "Enter Your Address",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                                  borderRadius:new BorderRadius.all(Radius.circular(25)),),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
                        child: TextFormField(
                            controller: Pin_Code,
                            validator: (Picode) {
                              if ((Picode)!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please Enter valid Name';
                              }
                            },
                            style: TextStyle(color: Colors.black,),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                hintText: "Enter Your Pin-Code",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                                  borderRadius:new BorderRadius.all(Radius.circular(25)),),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)
                                )
                            )
                        )
                    ),
                    SizedBox(height: 15,),
                    const Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Text("Select Gender",style: TextStyle(color:Colors.deepOrangeAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFeatures: [FontFeature.enable("smcp")])
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:13.0, right: 13),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              activeColor:Colors.deepOrangeAccent,
                              title:const Text("Male",style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [FontFeature.enable("smcp")]),),
                              value: "male",
                              groupValue: gender,
                              onChanged: (value){
                                setState(() {
                                  gender = value.toString();
                                  print(gender);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              activeColor:Colors.deepOrangeAccent,
                              title: const Text("Female",style: TextStyle(color:Colors.deepOrangeAccent,fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [FontFeature.enable("smcp")])),
                              value: "female",
                              groupValue: gender,
                              onChanged: (value){
                                setState(() {
                                  gender = value.toString();
                                  print(gender);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              activeColor: Colors.deepOrangeAccent,
                              title: const Text("Other",style: TextStyle(color:Colors.deepOrangeAccent,fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [FontFeature.enable("smcp")])),
                              value: "Other",
                              groupValue: gender,
                              onChanged: (value){
                                setState(() {
                                  gender = value.toString();
                                  print(gender);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    //profile pic upload
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Student profile pic upload
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(10),
                                child: Text("Select Student Profile", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500),),
                              ),
                            ),
                            Container(
                              height: 160.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                                    child: Stack(
                                        fit: StackFit.loose,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              ////////////THis is Command to show an image if is not null or else part by Conditon formatting.......
                                              image != null ? ClipOval(
                                                  child: Image.file(image!, height: 110,
                                                    width: 110,
                                                    fit: BoxFit.cover,)) :
                                              Container(
                                                  width: 120.0,
                                                  height: 120.0,
                                                  decoration:  const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: ExactAssetImage("assets/student1.jpg"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 75, left: 75),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor: Color(0xffC24641),
                                                    radius: 20.0,
                                                    child: InkWell(onTap: () {
                                                      option(context);
                                                    },
                                                      child: const Icon(
                                                        Icons.camera_alt, size: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        //Guardian profile pic upload
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(10),
                                child: const Text("Select Guardian Profile", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500),),
                              ),
                            ),
                            Container(
                              height: 160.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                                    child: Stack(
                                        fit: StackFit.loose,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              ////////////THis is Command to show an image if is not null or else part by Conditon formatting.......
                                              image1 != null ? ClipOval(child: Image.file(
                                                image1!, height: 110,
                                                width: 110,
                                                fit: BoxFit.cover,)) :
                                              Container(
                                                  width: 120.0,
                                                  height: 120.0,
                                                  decoration:  const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: ExactAssetImage("assets/student1.jpg"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),

                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 75, left: 75),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor: Color(0xffC24641),
                                                    radius: 20.0,
                                                    child: InkWell(onTap: () {
                                                      option1(context);
                                                    },
                                                      child: const Icon(
                                                        Icons.camera_alt, size: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //Document upload
                    Column(
                      children: [
                        Container(
                          width: 200,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrangeAccent,
                                shape:  RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                filename=null;
                                final result =
                                await FilePicker.platform.pickFiles(allowMultiple:true);
                                if (result == null) return;
                                PlatformFile file = result.files.first;
                                print(file.name);
                                print(file.bytes);
                                print(file.size);
                                print(file.extension);
                                print(file.path);
                                openFiles(result.files);
                                setState(() {
                                  filename=file.name;
                                  print(file.path);
                                  Filestore=file.path;
                                });
                              },
                              child: Row( mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(radius: 17, backgroundColor: Colors.white,child:Icon(Icons.file_copy, color: Colors.deepOrangeAccent,),),
                                  ),

                                  const Text("Select Documents", style: TextStyle(color: Colors.white),),
                                ],)
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(filename.toString()=="null"?"":filename.toString(),style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    ///next button...///
                    Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(right: 20.0,top: MediaQuery.of(context).size.height/7),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder:(context)=>Stud_regis1()));
                                    },
                                    child:Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(right: 0,left: 25,top: 10,bottom: 10),
                                        decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.arrow_back,color: Colors.white,),
                                            SizedBox(width: 3,),
                                            Text("Back",style: TextStyle(color: Colors.white),),
                                          ],
                                        ))
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(right: 0.0,top: MediaQuery.of(context).size.height/7),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: (){
                                      if (formGlobalKey.currentState!.validate() ) {
                                        formGlobalKey.currentState!.save();
                                        studentregi();

                                        // clearfile();
                                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_student_Page()));
                                        /* if( schoolname!.isNotEmpty && division!.isNotEmpty && section!.isNotEmpty  ){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Con()));
                                          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Registration Successfull...")));
                                        }
                                        else{
                                          scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Select All dropeDown Field")));
                                        }
                                      }*/}
                                      else{
                                        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Select All dropeDown Field",
                                          style: TextStyle(color: Colors.white),)));
                                      }
                                    },
                                    child: Container(
                                        width: 120,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                                        child: Center(child: Text("Register",style: TextStyle(color: Colors.white),)))
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),


        ),
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


              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: (){
                    fromcamera();
                  },
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: const [

                      CircleAvatar ( backgroundColor: Colors.grey, backgroundImage: AssetImage("assets/camera1.jpg",),)
                      ,SizedBox(width: 5,),
                      Text("Camera", style: TextStyle(color: Colors.black),),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              Padding( padding: EdgeInsets.only(left: 20,bottom: 20),
                child: InkWell( onTap: (){
                  fromGallary();
                },
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar ( backgroundColor: Colors.grey, backgroundImage: AssetImage("assets/image1.png",),),
                      SizedBox(width: 5,),
                      const Text("Gallary", style: TextStyle(color: Colors.black),),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ],
      );
    }
    );
  }
  option1(BuildContext context) {
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


              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: (){
                    fromcamera1();
                  },
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: const [

                      CircleAvatar ( backgroundColor: Colors.grey, backgroundImage: AssetImage("assets/camera1.jpg",),),
                      SizedBox(width: 5,),
                      Text("Camera", style: TextStyle(color: Colors.black),),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              Padding( padding: EdgeInsets.only(left: 20,bottom: 20),
                child: InkWell( onTap: (){
                  fromGallary1();
                },
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar ( backgroundColor: Colors.grey, backgroundImage: AssetImage("assets/image1.png",),),
                      SizedBox(width: 5,),
                      const Text("Gallary", style: TextStyle(color: Colors.black),),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ],
      );
    }
    );
  }

}
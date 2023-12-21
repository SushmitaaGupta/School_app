import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mydigischool/Login_&_Register/Login_Con.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

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
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
ImagePicker imagePicker = ImagePicker();
File? _image;
File? _image1;
File? _image2;
String? getschoolid;
String? getclassid;
String? schoolvalue;
String? classvalue;
String? sectionvalue;

Future studentregi() async {
  //var myurl="http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/saveDetail";
  var request = http.MultipartRequest('POST', Uri.parse("http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/saveDetail"));
  request.fields['student_name']=First_Name.text;
  request.fields['phone1'] = Mobile_Num.text;
  request.fields['phone2'] = P_Mobile_Num.text;
  request.fields['guardian_email'] =  Email_ID.text;
  request.fields['guardian_name'] = Father_Name.text;
  request.fields['gender'] = gender.toString();
  request.fields['dob'] = dateInput.text  ;
  request.fields['age'] = Age.text;
  request.fields['school_id'] =Admission_ID.text;
  request.fields['class_id']= Class.text;
  request.fields['section_id']= Section.text;
  request.fields['admission_id']=Admission_ID.text;
  request.fields['guardian_aadhar_no'] = Aadhar_no.text;
  request.fields['guardian_pan_no'] = Pancard_no.text;
  request.fields['address'] = Address.text;
  request.fields['pincode'] =Pin_Code.text;
  request.files.add(await http.MultipartFile.fromPath('student_profile_img', _image!.path));
  request.files.add(await http.MultipartFile.fromPath('birth_certificate', _image!.path));
  request.files.add(await http.MultipartFile.fromPath('guardian_profile_img', _image!.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

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


/// All About School or Getting Schoolid....
List jsonResponse=[];
class Schoolidclass {
  String pincode;
  String address;
  String schoolId;
  String schoolName;
  String status;

  Schoolidclass({
    required this.pincode,
    required this.address,
    required this.schoolId,
    required this.schoolName,
    required this.status
  });

  factory Schoolidclass.fromJson(Map<String, dynamic> json){
    return Schoolidclass(
      pincode: json["pincode"],
      address: json["address"],
      schoolId: json["schoolId"],
      schoolName: json["schoolName"],
      status: json["status"],
    );
  }

}
Future<List<Schoolidclass>> get_school_detail() async {

  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/get_school_detail";
  return http.get(Uri.parse(myurl)).then((response) {
    if (response.statusCode == 200) {
      print("before json response");
      print(response.body);
      jsonResponse = json.decode(response.body)['schoolList'];
      print("after json response");
      print(jsonResponse);
      print(jsonResponse[0]['pincode']);

      return jsonResponse.map((data) => Schoolidclass.fromJson(data)).toList();

    } else {
      throw Exception("unhandled error");
    }
  });
}

/// All About class or Getting classid with paramenter of schoolid.....
List jsonResponse1=[];
class ClassDetail {
  String classId;
  String schoolId;
  String className;

  ClassDetail({
    required this.classId,
    required this.schoolId,
    required this.className,

  });

  factory ClassDetail.fromJson(Map<String, dynamic> json){
    return ClassDetail(
      classId: json["classId"],
      schoolId: json["schoolId"],
      className: json["className"],

    );
  }

}
Future<List<ClassDetail>> class_detail() async {
  String  url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/class_detail";
  return http.post(Uri.parse(url), headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  },
      body: {
        "school_id": getschoolid,
      }).then((response) {
    if (response.statusCode == 200) {
      jsonResponse1 = json.decode(response.body)['classList'];
      print("Class List $jsonResponse1");

      return jsonResponse1.map((data) => ClassDetail.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}
List jsonResponse3=[];
class sectionDetail {
  String sectionName;
  String classId;
  String schoolId;
  String sectionId;

  sectionDetail({
    required this.sectionName,
    required this.classId,
    required this.schoolId,
    required this.sectionId,

  });

  factory sectionDetail.fromJson(Map<String, dynamic> json){
    return sectionDetail(
      sectionName: json["sectionName"],
      classId: json["classId"],
      schoolId: json["schoolId"],
      sectionId: json["sectionId"],

    );
  }

}
Future<List<sectionDetail>> section_detail() async {
  String  url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/section_detail";
  return http.post(Uri.parse(url), headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }, body: {
    "class_id": getclassid,
  }).then((response) {
    if (response.statusCode == 200) {
      jsonResponse3 = json.decode(response.body)['sectionList'];
      print("section List $jsonResponse3");

      return jsonResponse3.map((data) => sectionDetail.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}


class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
          imageVerticalOffset: 0,
          finishButtonText: 'Register',
          finishButtonTextStyle: TextStyle(color: Colors.white),
          onFinish: () {

            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>Login_Con(),
              ),
            );
          },
          finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.deepOrange
          ),

          controllerColor: Colors.deepOrange,
          trailingFunction: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const Login_Con(),
              ),
            );
          },

          totalPage: 3,
          headerBackgroundColor: Colors.transparent,
          pageBackgroundColor: Colors.transparent,
          background: [
            Image.asset(
              'assets/back.jpg',
              width: MediaQuery.of(context).size.width*1.15,
              height: MediaQuery.of(context).size.height*0.92,
            ),
            Image.asset(
              'assets/back.jpg',
              width: MediaQuery.of(context).size.width*1.15,
              height: MediaQuery.of(context).size.height*0.92,
            ),
            Image.asset(
              'assets/back.jpg',
              width: MediaQuery.of(context).size.width*1.15,
              height: MediaQuery.of(context).size.height*0.92,
            ),
          ],
          speed: 1.15,
          pageBodies: [
            SingleChildScrollView(
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
                    key: formGlobalKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
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
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                    hintText: "Enter Your Full Name",
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.school, color: Colors.deepOrangeAccent,),
                                  hintText: "Admission ID",
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.phone, color: Colors.deepOrangeAccent,),
                                  hintText: "Mobile number",
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.phone, color: Colors.deepOrangeAccent,),
                                  hintText: "Parents Mobile number",
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
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.mail, color: Colors.deepOrangeAccent,),
                                  hintText: "Email",
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                  hintText: "Guardian Name",
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
                          ),
                        ),

                        ///next button...///
                       /* Padding(
                          padding:  EdgeInsets.only(right: 20.0,top: MediaQuery.of(context).size.height/14),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: (){
                                    if (formGlobalKey.currentState!.validate()) {
                                      formGlobalKey.currentState!.save();
                                      *//* Navigator.push(context, PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => MyPage2Widget(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),*//*

                                      // use the email provided here
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
                        )*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
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
                                          color: Colors.black,
                                          width: 1.0,
                                          style: BorderStyle.solid
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 18.0),
                                                child: Text(
                                                  "Select School",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        iconEnabledColor: Colors.white,
                                        iconDisabledColor: Colors.white,
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
                                                      color: Colors.black,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      item.schoolName,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: Colors.black87,
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
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Expanded(
                                            child: Text(
                                              "Select Class",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: snapshot.data
                                          ?.map(
                                              (item) => DropdownMenuItem<String>(
                                            value: item.classId,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.list,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  item.className,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ],
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



                                );
                              }else{
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10, top: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const [
                                            Expanded(
                                              child: Text(
                                                "Select Class",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        items: []
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        "Select Class",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
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
                        classvalue != null && schoolvalue != null ? FutureBuilder<List<GetSectionData>>(
                            future: getAllSections(classvalue.toString()),
                            builder: (context, snapshot) {

                              if(snapshot.hasData && snapshot.data!.length > 0){
                                print("This is working");
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10, top: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          Expanded(
                                            child: Text(
                                              "Select Section",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: snapshot.data!.length > 0 ? snapshot.data
                                          ?.map(
                                              (item) => DropdownMenuItem<String>(
                                            value: item.sectionId,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.list,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  item.sectionName,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.blue,
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



                                );
                              }else{
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10, top: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Row(
                                          children: const [
                                            Expanded(
                                              child: Text(
                                                "Select Section",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        items: []
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        "Select Section",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0,bottom: 0.0, left: 8.0, right: 8.0),
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                                  hintText: "Enter Age",
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

                        ///next button...///
                       /* Padding(
                          padding:  EdgeInsets.only(right: 20.0,top: MediaQuery.of(context).size.height/7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: (){
                                    *//* Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPage1Widget()));*//*
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
                                    *//*  if (formGlobalKey.currentState!.validate()) {
                                      formGlobalKey.currentState!.save();
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPage3Widget()));
                                      //; use the email provided here
                                    }*//*
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
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
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
                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: const Text("Select Gender",style: TextStyle(color:Colors.deepOrangeAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                             )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:13.0, right: 13),
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  activeColor:Colors.deepOrangeAccent,
                                  title:Text("Male",style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),),
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
                                      )),
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
                                      )),
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
                        ElevatedButton(
                            onPressed:() async {
                              XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.gallery, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                              setState(() {
                                _image = File(image!.path);
                                print(_image);
                              });
                            },
                            child: const Text("Student image")
                        ),
                        ElevatedButton(
                            onPressed:() async {
                              XFile? image1 = await imagePicker.pickImage(
                                  source: ImageSource.gallery, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                              setState(() {
                                _image1= File(image1!.path);
                                print(_image1);
                              });
                            },
                            child: const Text("Parrants image")
                        ),
                        ElevatedButton(
                            onPressed:() async {
                              XFile? image2 = await imagePicker.pickImage(
                                  source: ImageSource.gallery, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                              setState(() {
                                _image2= File(image2!.path);
                                print(_image2);
                              });
                            },
                            child: const Text("Document upload")
                        ),
                        ///next button...///
                       /* Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(right: 20.0,top: MediaQuery.of(context).size.height/7),
                                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: (){
                                       *//*   Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPage2Widget()));*//*
                                        },
                                        child:Container(
                                            width: 120,
                                            padding: EdgeInsets.only(right: 0,left: 25,top: 10,bottom: 10),
                                            decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                                            child: Row(
                                              children: [
                                                Icon(Icons.arrow_back,color: Colors.white,),
                                                SizedBox(width: 3,),
                                                Text("Back",style: TextStyle(color: Colors.white),),
                                              ],
                                            ))
                                    )
                                  ],),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(right: 0.0,top: MediaQuery.of(context).size.height/7),
                                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: (){
                                          studentregi();
                                          if (formGlobalKey.currentState!.validate() ) {
                                            formGlobalKey.currentState!.save();
                                            if( schoolname!.isNotEmpty && division!.isNotEmpty && section!.isNotEmpty  ){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Con()));
                                              scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Registration Successfull...")));
                                            }
                                            else{
                                              scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Select All dropeDown Field")));
                                            }
                                          }
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
                        )*/
                      ],
                    ),
                  ),

                ],
              ),

            )
          ],
        );


  }
}

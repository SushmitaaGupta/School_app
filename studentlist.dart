import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



List jsonResponse=[];
String? classvalue;
String? sectionvalue;

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


Future<List<GetClassData>> getAllClasses() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/class_detail";
  return http.post(Uri.parse(myurl), body: {
    "school_id": sf.getString("TSchoolid").toString(),
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
  SharedPreferences sf = await SharedPreferences.getInstance();
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

Future<List<GetStudentDetail>> GetStudentDetail_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/studentDetailAsPerSection";
  return http.post(Uri.parse(myurl), body: {
    'class_id':classvalue,
    'section_id':sectionvalue,
    'school_id': sf.getString("TSchoolid").toString(),       //sf.getString("schoolId").toString(),
  }).then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body)['studentList'];
      print(jsonResponse);
      return jsonResponse.map((data) => GetStudentDetail.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}

class studentList extends StatefulWidget {
  const studentList({super.key});

  @override
  State<studentList> createState() => _studentListState();
}

class _studentListState extends State<studentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child:  Column(
          children: [
            FutureBuilder<List<GetClassData>>(
                future: getAllClasses(),
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
            ),
            FutureBuilder<List<GetSectionData>>(
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 14.0),
                                          child: const Icon(
                                            Icons.class_,
                                            size: 25,
                                            color: Colors.deepOrangeAccent,
                                          ),
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
                          child: Padding(
                            padding:  EdgeInsets.only(right: 15.0),
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
                    );
                  }return Container();
                }
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            SizedBox(height: 5,),
            Divider(
              color: Colors.deepOrangeAccent,
              thickness: 1,
            ),
            SizedBox(height: 5,),
            Table(
              border: TableBorder.all(width:1, color:Colors.deepOrangeAccent), //table border
              children: [
                TableRow(
                    children: [

                      TableCell(
                        child:   Padding(
                          padding: const EdgeInsets.only(top: 10.0,left: 15,bottom: 10),
                          child: Text("Name",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                        ),),
                      Center(
                        child: TableCell(
                          child:   Padding(
                            padding: const EdgeInsets.only(right: 10.0,top: 10),
                            child: Text("Guardian Name",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                          ),),
                      ),
                      Center(
                        child: TableCell(
                          child:   Padding(
                            padding: const EdgeInsets.only(left: 20.0,top: 10),
                            child: Text("Mobile No",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                          ),),
                      ),

                    ]
                ),





              ],
            ),


           /* Divider(
              color: Colors.black,
              thickness: 1,
            ),*/
            FutureBuilder<List<GetStudentDetail>>(
                future:GetStudentDetail_API() ,
                builder:(context, snapshot) {
                  List<GetStudentDetail>? data = snapshot.data;
                  if(snapshot.hasData){
                    print(data![0].name.toString());
                    return
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            for(int i= index; i<=data.length; i++){
                              // srn_no.add(i);
                              print(i);
                            }
                            return
                              Table(
                                border: TableBorder.all(width:1, color:Colors.deepOrangeAccent), //table border
                                children: [
                                  TableRow(
                                      children: [

                                        TableCell(
                                            child:   Padding(
                                              padding: const EdgeInsets.only(top: 10.0,left: 15,bottom: 10),
                                              child: Text("${data[index].name.toString()}",
                                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                                            ),),
                                        Center(
                                          child: TableCell(
                                              child:   Padding(
                                                padding: const EdgeInsets.only(right: 10.0,top: 10),
                                                child: Text("${data[index].guardianName.toString()}",
                                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                                              ),),
                                        ),
                                        Center(
                                          child: TableCell(
                                              child:   Padding(
                                                padding: const EdgeInsets.only(left: 20.0,top: 10),
                                                child: Text("${data[index].phone2.toString()}",
                                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                                              ),),
                                        ),

                                      ]
                                  ),





                                ],
                            );


                          });
                  }
                  else{}
                  return Container();
                }
            ),
          ],
        ),
      ),
    );
  }
}

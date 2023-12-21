import 'dart:convert';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool? isPresent;
  bool? isAbsent;

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
List jsonResponse=[];
String? schoolvalue;
String? classvalue;
String? sectionvalue;

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

Future<List<GetClassData>> getAllClasses() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/class_detail";
  return http.post(Uri.parse(myurl), body: {
    "school_id": /*sf.getString("schoolId").toString()*/"SCHOOL_77AB0A51BBFF",
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

Map<String,dynamic> pval = {};
Map<String,dynamic> pval2 = {};
Map<String,dynamic> aval = {};
Map<String,dynamic> aval2 = {};

Map<String,List<Map<String,dynamic>>> mmap1 = {};
Map<String,dynamic> mmap2 = {};
List l1 = [];



Future<List<GetStudentDetail>> GetStudentDetail_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/studentDetailApi/studentDetailAsPerSection";
  return http.post(Uri.parse(myurl), body: {
    'class_id':classvalue,
    'section_id':sectionvalue,
    'school_id': "SCHOOL_77AB0A51BBFF"/*sf.getString("schoolId").toString()*/,       //sf.getString("schoolId").toString(),
  }).then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body)['studentList'];
      //print(jsonResponse);
      if(pval2.isEmpty && aval2.isEmpty){
        for(var v in  jsonResponse) {
          pval = {v['studentId'].toString(): false};
          pval2.addAll(pval);
          aval = {v['studentId'].toString(): false};
          aval2.addAll(aval);
          l1.add(v['studentId'].toString());

        // mmap1 = {"attendlist":[{"studentId":v['studentId'].toString(),"attend":false}]};
         //mmap2.addAll(mmap1);


        }}

      print(l1);

      return jsonResponse.map((data) => GetStudentDetail.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}

class TeacherAttendenceNew extends StatefulWidget {
  const TeacherAttendenceNew({super.key});

  @override
  State<TeacherAttendenceNew> createState() => _TeacherAttendenceState();
}

bool?  is_present ;
bool? is_absent;
String? i;
List Attendence_data=[];
List srn_no1=['1','2','3','4','5'];

Future<String> jsonAllAttendance() async{
  Map<String,dynamic> l = {"attendancekey": Attendence_data,};
  String AllData_attendance_json = jsonEncode(l);
  print("This is the json of $AllData_attendance_json");
  return AllData_attendance_json;
}

extension AppendToListOnMapWithListsExtension<K, V> on Map<K, List<V>> {
void appendToList(K key, V value) =>
update(key, (list) => list..add(value), ifAbsent: () => [value]);
}

void checkjson(){
  pval2['date']= "22-07-23";
 mmap1.clear();
 mmap2.clear();

  for(int i = 0; i < l1.length; i++) {

      mmap1.appendToList("attendlist", {"studentId": l1[i], "attend": pval2[l1[i]]});
  }
  mmap2['date'] = "22-7-23";
  mmap2.addAll(mmap1);
  print(mmap2);

}



class _TeacherAttendenceState extends State<TeacherAttendenceNew> {
  @override
  void initState() {
    // TODO: implement initState
    pval.clear();
    pval2.clear();
    aval.clear();
    aval2.clear();
    mmap1.clear();
    mmap2.clear();
    l1.clear();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
          gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
        height:MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [

              FutureBuilder<List<GetClassData>>(
                  future: getAllClasses(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data!.length > 0){

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
                                    pval.clear();
                                    pval2.clear();
                                    aval.clear();
                                    aval2.clear();
                                    mmap1.clear();
                                    mmap2.clear();
                                    l1.clear();
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
                                    pval.clear();
                                    pval2.clear();
                                    aval.clear();
                                    aval2.clear();
                                    mmap1.clear();
                                    mmap2.clear();
                                    l1.clear();
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
              ),
              SizedBox(height: 15,),
              Table(
                // defaultColumnWidth: ,
                  border: TableBorder.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1),
                  children: [
                    TableRow( children: [
                      Column(children:[Text("Name", style: TextStyle(fontSize: 16.0, fontFeatures: [FontFeature.enable('smcp')]))]),
                      Column(children:[Text('Present', style: TextStyle(fontSize: 16.0, fontFeatures: [FontFeature.enable('smcp')]))]),
                      Column(children:[Text('Absent', style: TextStyle(fontSize: 16.0, fontFeatures: [FontFeature.enable('smcp')]))]),


                    ]),
                  ]),

            FutureBuilder<List<GetStudentDetail>>(
                  future:GetStudentDetail_API() ,
                  builder:(context, snapshot) {
                    List<GetStudentDetail>? data = snapshot.data;
                    if(snapshot.hasData){
                    return
                    ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data!.length,
                    itemBuilder: (context,index){
                      return Table(
                        //defaultColumnWidth: FixedColumnWidth(120.0),
                          border: TableBorder.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 1),
                          children: [
                            TableRow( children: [
                              Column(children:[
                                Padding(padding:EdgeInsets.only(top:10,bottom:10),
                                    child : Text(data[index].name, style: TextStyle(fontSize: 15.0, fontFeatures: [FontFeature.enable('smcp')])))

                              ]),
                              Column(children:[
                                pval2[data[index].studentId] == false ? InkWell(
                                    onTap: (){

                                      setState(() {
                                        pval2[data[index].studentId] = true;
                                        aval2[data[index].studentId] = false;


                                      });
                                    },
                                    child : Padding(padding:EdgeInsets.only(top:10,bottom:10),
                                      child : CircleAvatar(

                                          backgroundColor: Colors.white70,
                                          child: Icon(Icons.check)),


                                    )): InkWell(
                                  onTap: (){

                                    setState(() {
                                      pval2[data[index].studentId] = false;
                                    });
                                  },
                                  child : Padding(padding:EdgeInsets.only(top:10,bottom:10),
                                    child : CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Icon(Icons.check)),


                                  ),)

                              ]),
                              //here//

                              Column(children:[
                                aval2[data[index].studentId] == false ? InkWell(
                                    onTap: (){

                                      setState(() {
                                        aval2[data[index].studentId] = true;
                                        pval2[data[index].studentId] = false;
                                      });
                                    },
                                    child : Padding(padding:EdgeInsets.only(top:10,bottom:10),
                                      child : CircleAvatar(

                                          backgroundColor: Colors.white70,
                                          child: Icon(Icons.clear)),


                                    )): InkWell(
                                  onTap: (){

                                    setState(() {
                                      aval2[data[index].studentId] = false;
                                    });
                                  },
                                  child : Padding(padding:EdgeInsets.only(top:10,bottom:10),
                                    child : CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.clear)),


                                  ),),

                              ]),


                            ]),


                          ]);

                     });

    }
    return Container(); }),

            SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, //background color of button
                          side: BorderSide(width:1, color:Colors.brown), //border width and color
                          elevation: 1, //elevation of button
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: (){
                        checkjson();
                      }, child: Text("Mark Attendance")),
                  SizedBox(width: 10,),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
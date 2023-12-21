import 'dart:convert';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? selectedassignmenttype;
String? selectedsubjectid;
extension StringExtension on String {
String capitalize() {
  return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
}
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString =
      parse(document.body!.text).documentElement!.text;
  return parsedString;
}

class studentAssignment extends StatefulWidget {
  const studentAssignment ({Key? key}) : super(key: key);

  @override
  State<studentAssignment > createState() => studentAssignmentState();
}
List jsonResponse=[];

class Assignment_detail {
  String teacherName;
  String submissionDate;
  String className;
  String sectionId;
  String title;
  String type;
  String assignmentId;
  String sectionName;
  String subjectId;
  String classId;
  String teacherId;
  String schoolId;
  String assignmentInfo;
  String subjectName;




  Assignment_detail({
    required this.teacherName,
    required this.submissionDate,
    required this.className,
    required this.sectionId,
    required this.schoolId,
    required this.title,
    required this.classId,
    required this.sectionName,
    required this.type,
    required this.assignmentId,
    required this.subjectId,
    required this.teacherId,
    required this.assignmentInfo,
    required this.subjectName,

  });

  factory Assignment_detail.fromJson(Map<String, dynamic> json) {
    return Assignment_detail(
      teacherName: json['teacherName'],
      submissionDate: json['submissionDate'],
      title: json['title'],
      type: json['type'],
      schoolId: json['schoolId'],
      sectionId: json['sectionId'],
      classId: json['classId'],
      sectionName: json['sectionName'],
      className: json['className'],
      teacherId: json['teacherId'],
      subjectId: json['subjectId'],
      assignmentId: json['assignmentId'],
      subjectName: json['subjectName'],
      assignmentInfo: json['assignmentInfo'],

    );
  }
}

Future<List<Assignment_detail>> Assignment_detail_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  var url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/assignmentDetailApi/getTodayAssignment";
  Map mapdata = {
    "school_id": sf.getString("schoolId").toString(),
    "class_id":sf.getString("classId").toString(),
    "student_id":sf.getString("studentId").toString(),
    "section_id":sf.getString("sectionId").toString(),
    "assignment_type":selectedassignmenttype,
    "subject_id":selectedsubjectid

  };
  http.Response response = await http.post(Uri.parse(url), body: mapdata);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['assgingmnetDataList'];

    return jsonResponse.map((data) => Assignment_detail.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}


class GetSubjectData {
  String classId;
  String schoolId;
  String subjectName;
  String subjectId;


  GetSubjectData(
      {required this.classId,
        required this.subjectName,
        required this.schoolId,
        required this.subjectId,

      });

  factory GetSubjectData.fromJson(Map<String, dynamic> json) {
    return GetSubjectData(
      classId: json['classId'],
      subjectName: json['subjectName'],
      schoolId: json['schoolId'],
      subjectId: json['subjectId'],
     );
  }
}

Future<List<GetSubjectData>> getSubjects() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/subject_detail";
  return http.post(Uri.parse(myurl), body: {
    'class_id': sf.getString("classId").toString(),

  }).then((response) {
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['subjectList'];

      return jsonResponse.map((data) => GetSubjectData.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}




class studentAssignmentState extends State<studentAssignment> {

  final List<String> items = [
    'Assignment',
    'Home Work',
    'Project',
  ];



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
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              SizedBox(height: 30,),

              FutureBuilder<List<GetSubjectData>>(
                  future: getSubjects(),
                  builder: (context, snapshot) {

                    if(snapshot.hasData){
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10, top: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: const [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    "Select Subject",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            items: snapshot.data
                                ?.map((item) {

                              return DropdownMenuItem<String>(
                                value: item.subjectId,
                                child: Row(
                                  children: [


                                    Text(
                                      item.subjectName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            })
                                .toList(),
                            value: selectedsubjectid,
                            onChanged: (value) {
                              setState(() {

                                selectedsubjectid = value as String;




                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 260,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.yellow,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              offset: const Offset(-20, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility: MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),


                          ),


                        ),




                      );
                    }
                    return CircularProgressIndicator();
                  }
              ),

          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  Icon(
                    Icons.list,
                    size: 16,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Select Assignment Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList(),
              value: selectedassignmenttype,
              onChanged: (String? value) {
            setState(() {
            selectedassignmenttype = value;
            });
            },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 260,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.white,
                ),
                elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                offset: const Offset(-20, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ),


             selectedassignmenttype !=null && selectedsubjectid != null ?
             FutureBuilder<List<Assignment_detail>>(
                  future: Assignment_detail_API(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Assignment_detail>? data = snapshot.data;

                    return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                       itemCount: data!.length,
                    itemBuilder:(context,i) {
                    return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [

                    SizedBox(height:20),



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

                    selectedassignmenttype == "Assignment" ? Padding(
                    padding: EdgeInsets.only(top:10,left:18,bottom:5),
                    child: Text("Assignment " + (i+1).toString(),style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ): selectedassignmenttype == "Home Work" ? Padding(
                    padding: EdgeInsets.only(top:10,left:18,bottom:5),
                    child: Text("Home Work " + (i+1).toString(),style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ): Padding(
                    padding: EdgeInsets.only(top:10,left:18,bottom:5),
                    child: Text("Project " + (i+1).toString(),style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:10,left:18,bottom:5),
                    child: Expanded(child : Text(data[i].title.toString().capitalize(),style: TextStyle(color: Colors.black,fontWeight:FontWeight.w400,fontSize:16, fontFeatures: [FontFeature.enable('smcp')]),),),
                    ),

                    Padding( padding: EdgeInsets.only(top:10,left:18,bottom:5,right:18),

                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Teacher Name",
                    style: TextStyle( color:Colors.black,fontWeight: FontWeight.w400, fontSize: 15, fontFeatures: [FontFeature.enable('smcp')]),),
                    SizedBox(height: 7,),
                    Text(data[i].teacherName.toString().capitalize(),
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),)
                    ],
                    ),
                    Column(
                    children: [
                    Text("Subject",
                    style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400, fontSize: 15)),
                    SizedBox(height: 7,),
                    Text(data[i].subjectName.toString(),
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
                    ],
                    ),

                    ],
                    ),),

                    Padding( padding: EdgeInsets.only(top:10,left:18,bottom:5,right:18),

                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Submission date",
                    style: TextStyle( color:Colors.black,fontWeight: FontWeight.w400, fontSize: 15, fontFeatures: [FontFeature.enable('smcp')]),),
                    SizedBox(height: 7,),
                    Text(data[i].submissionDate.toString().capitalize(),
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),)
                    ],
                    ),
                    Column(
                    children: [
                    Text("Class",
                    style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400, fontSize: 15)),
                    SizedBox(height: 7,),
                    Text(data[i].className.toString(),
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
                    ],
                    ),

                    ],
                    ),),

                    Divider(
                    thickness: 1,
                    color: Colors.grey,
                    ),

                    Padding(
                    padding: EdgeInsets.only(top:10,left:18,bottom:5),
                    child: Text(_parseHtmlString(data[i].assignmentInfo.toString()),style: TextStyle(color: Colors.black,fontWeight:FontWeight.w300,fontSize:15, fontFeatures: [FontFeature.enable('smcp')]),),
                    ),



                    SizedBox(height:10),

                    ],
                    ),),),),




                    ]

                    );});
                    } else {
                    return Container();

                    }
                  }):Container(),
              SizedBox(height: 5,),





            ],
          ),
        ),
      ),
    );
  }
}
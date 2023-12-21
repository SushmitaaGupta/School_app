import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


String? severity;
String? Filestore;
String? filename;
bool isLoading=false;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
String? teacher_id;


var raised_complaint_for = [
  'Select Complaint type',
  'Teacher','Ingeneral','School'
];

var currentItemSelected = 'Select Complaint type';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

List<PlatformFile> files = [];
void openFiles(List<PlatformFile> files) {
  //show(files: files);
}

void clearfile() {
  titles.clear();
  description.clear();
  currentItemSelected = 'Select Complaint type';
  Filestore!.isEmpty;
  filename!.isEmpty.toString();
}


TextEditingController titles = TextEditingController();
TextEditingController description = TextEditingController();

class TeacherList{
  String? name;
  String? teacherId;

  TeacherList({this.name, this.teacherId });

  factory TeacherList.fromJson(Map<String, dynamic> json){
    return TeacherList(
        name: json['name'],
        teacherId: json['teacherId']
    );
  }
}

class S_Compaint extends StatefulWidget {
  const S_Compaint({super.key});

  @override
  State<S_Compaint> createState() => _S_CompaintState();
}

class _S_CompaintState extends State<S_Compaint> {

  Future<List<TeacherList>> TeacherList_Api() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String myurl =  "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/teacherDetailApi/teacherDetailAsPerSchool";
    return http.post(Uri.parse(myurl), body: {
      "school_id": sf.getString("schoolId").toString()
    }).then((response) {
      if(response.statusCode==200) {
        List jsonResponse = json.decode(response.body)['teacherList'];

        // sf.setString("teacherId", jsonResponse[0]['teacherId'].toString());
        teacher_id =  jsonResponse[0]['teacherId'].toString();
        print(jsonResponse);

        return jsonResponse.map((data) => TeacherList.fromJson(data)).toList();
      }
      else{

        throw Exception('Unexpected error occurred! in maincategory');
      }

    });
  }


  Future<bool> Student_Compaint() async {

    SharedPreferences sf = await SharedPreferences.getInstance();
    print("teacher");
    print(teacher_id.toString());
    var request = http.MultipartRequest('POST', Uri.parse("http://103.148.157.74:33178/DigiSchoolWebAppNew/android/complaintDetailApi/saveDetail"));
    request.fields['title']=titles.text;
    request.fields['severity'] = severity.toString();
    request.fields['complaint_for'] = currentItemSelected.toString();
    request.fields['teacherId'] =  teacher_id.toString();
    request.fields['description'] = description.text;
    request.fields['studentId'] =sf.getString("studentId").toString();
    request.fields['schoolId'] = sf.getString("schoolId").toString() ;

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      const snackBar = SnackBar(
        content: Text('Your Complaint successfully send'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      clearfile();

      return true;
    } else {

      const snackBar = SnackBar(
        content: Text('Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return false;
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TeacherList_Api();
    print(teacher_id);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text("Compaint"),
        ),
        body:  SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Column(
                    children: [
                      SizedBox(height: 8,),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Text("Select Severity",style: TextStyle(color:Colors.deepOrangeAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:13.0, right: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                activeColor:Colors.deepOrangeAccent,
                                title:const Text("Urgent",style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),),
                                value: "Urgent",
                                groupValue: severity,
                                onChanged: (value){
                                  setState(() {
                                    severity = value.toString();
                                    print(severity);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                activeColor:Colors.deepOrangeAccent,
                                title: const Text("Routine",style: TextStyle(color:Colors.deepOrangeAccent,fontSize: 12,
                                  fontWeight: FontWeight.bold,)),
                                value: "Routine",
                                groupValue: severity,
                                onChanged: (value){
                                  setState(() {
                                    severity = value.toString();
                                    print(severity);
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(
                                  color:  Colors.deepOrangeAccent, width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              iconEnabledColor: Colors.deepOrangeAccent,
                              iconDisabledColor: Colors.deepOrangeAccent,
                              items: raised_complaint_for.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Center(
                                      child: Text(
                                        dropDownStringItem,
                                        style: const TextStyle(fontSize: 18),
                                      )),
                                );
                              }).toList(),
                              onChanged: (var newValueSelected) {
                                setState(() {
                                  currentItemSelected = newValueSelected!;
                                });
                              },
                              value: currentItemSelected,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                          child: TextFormField(
                              controller: titles,
                              validator: (Title) {
                                if ((Title)!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Please Enter Title';
                                }
                              },
                              style: TextStyle(color: Colors.black,),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  prefixIcon: Icon(Icons.title,
                                    color: Colors.deepOrangeAccent,),
                                  hintText: "Enter Title",
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
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, bottom: 0.0, left: 8.0, right: 8.0),
                          child: TextFormField(
                              maxLines: 5,
                              controller: description,
                              validator: (Description) {
                                if ((Description)!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Please Enter Description';
                                }
                              },
                              style: TextStyle(color: Colors.black,),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  //prefixIcon: Icon(Icons.title, color: Colors.deepOrangeAccent,),
                                  hintText: "       ${ "Please write Description...."}",

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 32.0),
                                      borderRadius: BorderRadius.circular(20.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.deepOrangeAccent),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(20)),),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 32.0),
                                      borderRadius: BorderRadius.circular(25.0)
                                  )
                              )
                          )
                      ),

                      SizedBox(height: 20,),
                      InkWell(
                          onTap: () async {
                            if(_formkey.currentState!.validate()) {

                            setState((){
                            isLoading=true;
                            });
                            await Future.delayed(const Duration(seconds: 0));
                            setState(() {
                            isLoading=false;
                            Student_Compaint();

                            });

                            }
                            else{

                            const snackBar = SnackBar(
                            content: Text('Please select all the fields..'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            }

                          },
                          child:Container(
                            width: 120,
                            padding: const EdgeInsets.only(right: 0,left: 0,top: 10,bottom: 10),
                            decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                            child: Center(child: Text("Submit",style: TextStyle(color: Colors.white),)),
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}
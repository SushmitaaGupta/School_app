import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Login_&_Register/Login_Con.dart';
import '../Login_&_Register/Login_student_page.dart';
import '../Login_&_Register/Login_teacher_page.dart';
import '../Login_&_Register/Register_Con.dart';
import 'package:http/http.dart' as http;

class Teaches_regis extends StatefulWidget {
  const Teaches_regis({Key? key}) : super(key: key);
  @override
  State<Teaches_regis> createState() => _Teaches_regisState();
}

TextEditingController _tname = new TextEditingController();
TextEditingController _temail = new TextEditingController();
TextEditingController _tpphone = new TextEditingController();
TextEditingController _tophone = new TextEditingController();
TextEditingController _SchoolName = new TextEditingController();
TextEditingController _officeId = new TextEditingController();
TextEditingController _tschool_id = new TextEditingController();
TextEditingController _tAddress = new TextEditingController();
TextEditingController _tAadhar_no = new TextEditingController();
TextEditingController _Tpan_Card_no = new TextEditingController();
String? gender;
String? schoolvalue;
ImagePicker imagePicker = ImagePicker();
File? _image;


class GetSchoolData {
  String schoolId;

  GetSchoolData(
      {
        required this.schoolId,

      });

  factory GetSchoolData.fromJson(Map<String, dynamic> json) {
    return GetSchoolData(
      schoolId: json['schoolId']

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

Future teacherregi() async {
  //var myurl="http://103.148.157.74:33178/DigiSchoolWebAppNew/android/teacherDetailApi/saveDetail";
  var request = http.MultipartRequest('POST', Uri.parse("http://103.148.157.74:33178/DigiSchoolWebAppNew/android/teacherDetailApi/saveDetail"));
  request.fields['teacher_name']=_tname.text;
  request.fields['email'] = _temail.text;
  request.fields['personal_mobile_no'] = _tpphone.text;
  request.fields['office_mobile_no'] =  _tophone.text;
  request.fields['office_id'] = _officeId.text;
  request.fields['gender'] = gender.toString();
  request.fields['address'] = _tAddress.text  ;
  request.fields['aadhar_no'] = _tAadhar_no.text;
  request.fields['school_id'] =schoolvalue.toString();
  request.files.add(await http.MultipartFile.fromPath('student_profile_img', _image!.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    print("success");
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

final formGlobalKey = GlobalKey<FormState>();
final formGlobalKey1 = GlobalKey<FormState>();

void clearfile1() {
  _tname.clear();
  _temail.clear();
  _tpphone.clear();
  _tophone.clear();
  _officeId.clear();
  _tAddress.clear();
  _tAadhar_no.clear();

}

class _Teaches_regisState extends State<Teaches_regis> {
  final _controller = PageController(
    initialPage: 0,);
  DateTime selectedDate = DateTime.now();

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/back.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Create Your Account", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, ),)
                  ],),
                SizedBox(height: 5,),
                Text("Please Enter your information tocreate account "),
                /////Forms Starts From here......//////////
                Padding(
                  padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                  child: TextFormField(
                      validator: (firstName) {
                        if ((firstName)!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please Enter valid Name';
                        }
                      },
                      controller: _tname,
                      style: TextStyle(color: Colors.black,),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
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

                  ),

                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                        controller: _temail,
                        validator: (email) {
                          if ((email)!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Enter valid email';
                          }
                        },
                        style: TextStyle(color: Colors.black,),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
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
                            )))
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                        controller: _tpphone,
                        validator: (mobile) {
                          if ((mobile)!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Enter valid mobile number';
                          }
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        cursorColor:Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.phone, color: Colors.deepOrangeAccent,),
                            hintText: " Official Mobile number",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                              borderRadius:new BorderRadius.all(Radius.circular(25)),),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)
                            )))
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                        controller: _tophone,
                        validator: (tophone) {
                          if ((tophone)!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Enter valid mobile number,';
                          }
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        cursorColor:Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.phone, color: Colors.deepOrangeAccent,),
                            hintText: "Personal Mobile Number",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                              borderRadius:new BorderRadius.all(Radius.circular(25)),),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)
                            )))
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                        controller: _tAddress,
                        validator: (Address) {
                          if ((Address)!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Enter valid Address';
                          }
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        cursorColor:Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.location_city, color: Colors.deepOrangeAccent,),
                            hintText: "  Address",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                              borderRadius:new BorderRadius.all(Radius.circular(25)),),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)
                            )))
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                        controller: _tAadhar_no,
                        validator: (Aadhar_no) {
                          if ((Aadhar_no)!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please Enter valid Aadhar_no';
                          }
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.numbers, color: Colors.deepOrangeAccent,),
                            hintText: "Enter Aadhar_no",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                              borderRadius:new BorderRadius.all(Radius.circular(25)),),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)
                            )))
                ),
                ///next button...///
                Padding(
                  padding:  EdgeInsets.only(right: 20.0,top: MediaQuery.of(context).size.height/14),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: (){
                            if (formGlobalKey.currentState!.validate()) {
                              formGlobalKey.currentState!.save();

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Teaches_regis1()));
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class Teaches_regis1 extends StatefulWidget {
  const Teaches_regis1({super.key});

  @override
  State<Teaches_regis1> createState() => _Teaches_regis1State();
}

class _Teaches_regis1State extends State<Teaches_regis1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(
          image: AssetImage("assets/back.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: formGlobalKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Create Your Account", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, ),)
                  ],),
                SizedBox(height: 5,),
                Text("Please Enter your information tocreate account "),
                /////Forms Starts From here......//////////
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
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.school,
                                          size: 25,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            "Select School_ID",
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
                                                width: 18,
                                              ),
                                              Text(
                                                item.schoolId,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.black,
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
                Padding(
                    padding: const EdgeInsets.only(top: 25.0,bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextField(
                        controller: _officeId,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        cursorColor:Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
                            hintText: "Office Id",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide( color: Colors.deepOrangeAccent),
                              borderRadius:new BorderRadius.all(Radius.circular(25)),),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)
                            )))
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrangeAccent, //background color of button
                            side: BorderSide(width:1, color:Colors.deepOrangeAccent), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder( //to set border radius to button
                                borderRadius: BorderRadius.circular(30)
                            ),
                            padding: EdgeInsets.all(12) //content padding inside button

                        ),
                        onPressed:() async {
                          XFile? image = await imagePicker.pickImage(
                              source: ImageSource.gallery, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                          setState(() {
                            _image = File(image!.path);
                            print(_image);
                          });
                        },
                        child: const Text("Teacher image",
                          style: TextStyle(fontWeight: FontWeight.w300),)
                    ),
                    Center(
                        child: Expanded(
                            child: Text("Path: "+_image.toString())))
                  ],
                ),
                ///next button...///
                Padding(
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Teaches_regis()));
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

                                  if (formGlobalKey1.currentState!.validate() ) {
                                    formGlobalKey1.currentState!.save();
                                    teacherregi();
                                    clearfile1();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Con()));

                                    /* if( schoolname!.isNotEmpty && division!.isNotEmpty && section!.isNotEmpty  ){

                                      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Registration Successfull...")));
                                    }*/
                                    /*else{
                                      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Select All dropeDown Field")));
                                    }*/
                                  }


                                  /*else{
                                    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Select All dropeDown Field",
                                      style: TextStyle(color: Colors.white),)));
                                  }*/
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
        ),
      ),
    );
  }
}


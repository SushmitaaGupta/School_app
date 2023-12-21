import 'dart:convert';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mydigischool/Login_&_Register/Login_Con.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'studentHome.dart';
import 'package:http/http.dart' as http;

import 'studentassignment.dart';
import 'studentprofile.dart';

class studentNavBar extends StatefulWidget {
  const studentNavBar({Key? key}) : super(key: key);

  @override
  State<studentNavBar> createState() => _studentNavBarState();
}
TextEditingController _serchController = TextEditingController();
List jsonResponse=[];
SimpleFontelicoProgressDialog? _dialog;
String? LoginStudent;



getStudentLogin() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  LoginStudent= sf.getString("student");
}

class Student_Profile_detail {
  String studentProfileImgPath;
  String name;
  String emailId;
  String phone1;
  String schoolId;
  String?studentId;
  String?classId;
  String?sectionId;
  Student_Profile_detail({
    required this.studentProfileImgPath,
    required this.name,
    required this.emailId,
    required this.phone1,
    required this.schoolId,
    required this.studentId,
    required this.classId,
    required this.sectionId,
  });

  factory Student_Profile_detail.fromJson(Map<String, dynamic> json) {
    return Student_Profile_detail(
      studentProfileImgPath: json['studentProfileImgPath'],
      name: json['name'],
      emailId: json['emailId'],
      phone1: json['phone1'],
      schoolId: json['schoolId'],
      studentId: json['studentId'],
      classId: json['classId'],
      sectionId: json['sectionId'],
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
    sf.setString("schoolId", jsonResponse[0]['schoolId'].toString());
    sf.setString("studentId", jsonResponse[0]['studentId'].toString());
    sf.setString("classId", jsonResponse[0]['classId'].toString());
    sf.setString("sectionId", jsonResponse[0]['sectionId'].toString());
    //sf.setString("studentId", jsonResponse[0]['studentId'].toString());
    return jsonResponse.map((data) => Student_Profile_detail.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}


class _studentNavBarState extends State<studentNavBar> {
  int _index = 0;
  Future<List<Student_Profile_detail>>? stude_pro;

  @override
  void initState() {
    // TODO: implement initState
   // _bottomSheet();
    getStudentLogin();
   stude_pro = Student_Profile_detail_API();
   print(stude_pro);
    super.initState();
  }

  void _incrementTab(index) {
    setState(() {
      _index = index;
    });
  }

  void _showDialog(BuildContext context, SimpleFontelicoProgressDialogType type,
      String text) async {
    if (_dialog == null) {
      _dialog = SimpleFontelicoProgressDialog(
          context: context, barrierDimisable: false);
    }
    if (type == SimpleFontelicoProgressDialogType.custom) {
      _dialog!.show(
          message: text,
          type: type,
          width: 150.0,
          height: 75.0,
          loadingIndicator: Text(
            'LogOut',
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
          hideText: false);

    }

    else {
      _dialog!.show(
          message: "Logout",
          type: type,
          horizontal: true,
          width: 150.0,
          height: 75.0,
          loadingIndicator:
          Text("LogOut",
            style: TextStyle(color: Colors.black),
          ),
          hideText: false,
          indicatorColor: Colors.red);

    }
    await Future.delayed(Duration(seconds: 1));
    _dialog!.hide();
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.remove("student");

    sf.clear();
    Navigator.pop(context);
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login_Con()));
  }

  final List<String> title=[
    'Home',
    'Assignment',
    'Profile'
  ];

  final List<Widget> view=[
    const studentHome(),
    const studentAssignment(),
    const studentProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
        gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Column(
            children: [
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("GOOD MORNING!", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 3,),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title[_index].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.transparent,


          actions: [
            InkWell(
              onTap: (){
                /*Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));*/
              },
              child: FutureBuilder<List<Student_Profile_detail>>(
                  future: stude_pro,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return  Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundImage:
                          NetworkImage("http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['studentProfileImgPath'].toString()}"),
                        ),
                      );

                    }
                    return CircleAvatar(
                    backgroundImage:
                    AssetImage("assets/maleteacher.jpg"),
                    ) ;

                  }
              ),
            )
          ],
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              FutureBuilder<List<Student_Profile_detail>>(
                  future: stude_pro,
                  builder: (context, snapshot) {
                    List<Student_Profile_detail>? data = snapshot.data;
                    if (snapshot.hasData) {
                      return Column(children: [
                        SizedBox(
                          height: 245,
                          child: UserAccountsDrawerHeader(
                            decoration: const BoxDecoration(
                              color:Colors.deepOrangeAccent,
                            ),
                            accountName: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(jsonResponse[0]['name'].toString(),
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(jsonResponse[0]['phone1']
                                      .toString(),
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            accountEmail: Text(
                              jsonResponse[0]['emailId']
                                  .toString()
                                  .toString(),
                              style: TextStyle(fontSize: 15),
                            ),

                            currentAccountPicture:
                                'http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['studentProfileImgPath'].toString()}' ==
                                null ||
                                "http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['studentProfileImgPath'].toString()}" ==
                                    "NA"
                                ? CircleAvatar(
                              backgroundColor: Color(0xff856f1d),
                              child: Text(
                                jsonResponse[0]['name'][0]
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                                : CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(
                                    'http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['studentProfileImgPath'].toString()}',
                              ),
                            ),
                          ),
                        ),
                      ]);
                    } else {
                      return Container(
                        height: 245,
                        child: UserAccountsDrawerHeader(
                          decoration: const BoxDecoration(
                            color: Colors.deepOrangeAccent,
                          ),
                          accountName: Text("Username"),
                          accountEmail: Text("Usermail@gmail.com"),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: AssetImage("assets/man.png"),
                            // AssetImage('assets/img_7.png',),
                          ),
                        ),
                      );
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.deepOrangeAccent),
                title: const Text("Home"),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => studentHome()));
                },
              ),
              const Divider(
                height: 11,
                thickness: 0.4,
                // indent: 20,
                // endIndent: 0,
                color:Colors.deepOrangeAccent,
              ),
              ListTile(
                leading:
                const Icon(Icons.person, color: Colors.deepOrangeAccent),
                title: const Text("Contact Us"),
                onTap: () {
                 /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Contact()));*/
                },
              ),
              const Divider(
                height: 11,
                thickness: 0.4,
                // indent: 20,
                // endIndent: 0,
                color: Colors.deepOrangeAccent,
              ),
              ListTile(
                leading:
                const Icon(Icons.help, color: Colors.deepOrangeAccent),
                title: const Text("Help & Support"),
                onTap: () {
                /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Helpandsupport()));*/
                },
              ),
              const Divider(
                height: 11,
                thickness: 0.4,
                color: Colors.deepOrangeAccent
              ),

              ListTile(
                leading:
                const Icon(Icons.logout, color: Colors.deepOrangeAccent),
                title: const Text("Logout"),
                onTap: () async {
                  final value = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:  Colors.deepOrangeAccent,
                          content: const Text(
                            'Are you sure you want to exit?',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<
                                            Color>(Colors.white),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20)))),
                                    child: const Text('No',
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent)),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<
                                            Color>(Colors.white),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                          ),
                                        )),
                                    child: const Text('Yes',
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent)),
                                    onPressed: () async {
                                      _showDialog(context, SimpleFontelicoProgressDialogType.normal, "");
                                      SharedPreferences sf = await SharedPreferences.getInstance();
                                      await sf.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
              /*Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.24,
                    left: 25),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepOrangeAccent,
                      radius: 2,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    InkWell(
                        onTap: () {

                        },
                        child: const Text(
                          "Terms & condition",
                          style: TextStyle(
                              fontSize: 10, color: Color(0xffb76502)),
                        )),
                    const SizedBox(
                      width: 5,
                    ),

                    const CircleAvatar(
                      backgroundColor: Color(0xff356978),
                      radius: 2,
                    ),

                    SizedBox(
                      width: 2,
                    ),
                    InkWell(
                        onTap: () {

                        },
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                              fontSize: 10, color: Color(0xffb76502)),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    const CircleAvatar(
                      backgroundColor: Color(0xff356978),
                      radius: 2,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    InkWell(
                        onTap: () {

                        },
                        child: const Text(
                          "Refund Policy",
                          style: TextStyle(
                              fontSize: 10, color: Color(0xffb76502)),
                        )),
                  ],
                ),
              )*/
            ],
          ),
        ),
        bottomNavigationBar: FloatingNavbar(
          backgroundColor: Colors.grey.shade400,
          selectedItemColor: Color(0xff0B6E4F),
          onTap: (_index){
            _incrementTab(_index);
          },
          currentIndex: _index,
          selectedBackgroundColor: Colors.white70,

          items: [
            FloatingNavbarItem(icon: Icons.home, title: 'Home'),
            FloatingNavbarItem(icon: Icons.assignment, title: 'Assignment'),
            FloatingNavbarItem(icon: Icons.person_2_rounded, title: 'Profile'),
          ],
        ),

        body: Center(
          child: view[_index],
        ),
      ),
    );
  }
  _bottomSheet() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Wrap(
              children: [
                Column( mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(padding: EdgeInsets.all(10),
                      child: Text("Mobile commerce is growing every year as more and more customers shop exclusively on their phones. An effective mobile app can go a long way toward offering a customizable experience that shoppers can’t get anywhere else."
                          "Having a strong mobile component is increasingly important to modern ecommerce — and almost expected by customers. But a quick search of any app store shows just how difficult it can be to really stand out from all the competition."
                          "In this article, we’ve compiled a list of the 11 best mobile ecommerce apps available today, highlighting the capabilities and key features of each, to help you find some inspiration for your business.",
                        style: TextStyle(fontWeight: FontWeight.w300),),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(onPressed: (){},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                              child: Text("Letest Product")),
                        ],
                      ),
                    )
                  ],

                ),
              ],
            );

          });

    });
  }
}
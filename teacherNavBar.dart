import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mydigischool/Home/Teacher_home/studentlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../../Login_&_Register/Login_Con.dart';
import 'Profile.dart';
import 'attendance.dart';
import 'attendancenew.dart';
import 'teacherHome.dart';
import 'package:http/http.dart' as http;


class teacherNavBar extends StatefulWidget {
  const teacherNavBar({Key? key}) : super(key: key);

  @override
  State<teacherNavBar> createState() => _teacherNavBarState();
}

TextEditingController _serchController = TextEditingController();
List jsonResponse=[];
SimpleFontelicoProgressDialog? _dialog;

class Teacher_Profile_detail {
  String studentProfileImgPath;
  String name;
  String email;
  String officeMobileNo;

  Teacher_Profile_detail({
    required this.studentProfileImgPath,
    required this.name,
    required this.email,
    required this.officeMobileNo,
  });

  factory Teacher_Profile_detail.fromJson(Map<String, dynamic> json) {
    return Teacher_Profile_detail(
      studentProfileImgPath: json['profileImgPath'],
      name: json['name'],
      email: json['email'],
      officeMobileNo: json['officeMobileNo'],
    );
  }
}

Future<List<Teacher_Profile_detail>> Teacher_Profile_detail_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  var url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/teacherDetailApi/teacherDetail";
  Map mapdata = {
    "teacher_id":sf.getString("teacherid").toString(),
  };
  http.Response response = await http.post(Uri.parse(url), body: mapdata);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body)['teacherList'];
    sf.setString("TSchoolid", jsonResponse[0]['schoolId'].toString());
    sf.setString("Tname", jsonResponse[0]['name'].toString());
    print(jsonResponse);
    return jsonResponse.map((data) => Teacher_Profile_detail.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}

class _teacherNavBarState extends State<teacherNavBar> {
  int _index = 0;
  Future<List<Teacher_Profile_detail>>? teacher_pro;

  @override
  void initState() {
    // TODO: implement initState
    getTeacherLogin();
    teacher_pro = Teacher_Profile_detail_API();
    super.initState();
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
    sf.remove("teacher");
    Navigator.pop(context);
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login_Con()));
  }

  void _incrementTab(index) {
    setState(() {
      _index = index;
      print(_index);
    });
  }

  String? LoginTeacher;
  getTeacherLogin() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    LoginTeacher= sf.getString("teacher");
  }


  final List<String> title = [
    'Home',
    'Self Attendance',
    'Student List'
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    const teacherHome(),
    const TeacherAttendenceNew(),
    const studentList(),
  ];

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
         gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),
      ),
      child: Theme(
        data: ThemeData(
            primaryIconTheme: IconThemeData(color: Colors.red),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 14),
                Text("Good Morning..",
                  style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(width: 5),
                Text("sachin".toString(),
                  style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w400),),
              ],
            ),

            //leading: Icon(Icons.menu, color: Colors.green),
            backgroundColor: Colors.transparent,
            /*leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.black,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),*/
            actions: [
              Row(
                children: [

                  Icon(Icons.notifications_rounded, color: Colors.grey),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>profile()));
                    },
                    child: FutureBuilder<List<Teacher_Profile_detail>>(
                        future: teacher_pro,
                        builder: (context, snapshot) {

                          List<Teacher_Profile_detail>? data = snapshot.data;
                          print(data);
                          if (snapshot.hasData) {
                            return  Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['profileImgPath'].toString()}"),
                        ),
                    );
                          }
                          return CircleAvatar(
                            backgroundImage:
                            AssetImage("assets/maleteacher.jpg"),
                          ) ;
                        }
                        ),
                  ),
                ],
              )
            ],
          ),

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                FutureBuilder<List<Teacher_Profile_detail>>(
                    future: teacher_pro,
                    builder: (context, snapshot) {
                      print("TEXT");
                      List<Teacher_Profile_detail>? data = snapshot.data;
                      print(data);
                      if (snapshot.hasData) {
                        return Column(children: [
                          SizedBox(
                            height: 245,
                            child: UserAccountsDrawerHeader(
                              decoration: const BoxDecoration(
                                color:Colors.deepOrangeAccent,
                              ),
                              accountName: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(jsonResponse[0]['name'].toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(jsonResponse[0]['officeMobileNo'].toString(),
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              accountEmail: Text(
                                jsonResponse[0]['email'].toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              currentAccountPicture:
                              'http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['profileImgPath'].toString()}' ==
                                  null ||
                                  "http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['profileImgPath'].toString()}" ==
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
                                  'http://103.148.157.74:33178/DigiSchoolWebAppNew/${jsonResponse[0]['profileImgPath'].toString()}',
                                ),
                              ),
                            ),
                          ),

                        ]);
                      } else {
                        return  Container(
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
                    Navigator.pop(context);
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
                                              color: Color(0xff396577))),
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
                                              color: Color(0xff396577))),
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

          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                label: 'Self Attendance',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Student List',
              ),
            ],
            currentIndex:_index,
            selectedItemColor: Colors.amber[800],
            onTap: _incrementTab,
          ),

          body: Center(
            child: _widgetOptions[_index],
          ),

        ),
      ),
    );
  }
}


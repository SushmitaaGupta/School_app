import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home/Student_home/studentNavBar.dart';
import 'Home/Teacher_home/teacherNavBar.dart';
import 'Login_&_Register/Login_Con.dart';
import 'SplashScreen.dart';

var LoginStudent;
var LoginTeacher;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  SharedPreferences sf = await SharedPreferences.getInstance();
  LoginStudent= sf.getString("student");
  LoginTeacher= sf.getString("teacher");
  runApp( const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

void enterFullScreen(FullScreenMode fullScreenMode) async {
  await FullScreen.enterFullScreen(fullScreenMode);
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    super.initState();
  }

 // LoginStudent == null? LoginTeacher==null? Login_Con():studentNavBar(): teacherNavBar()

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash()
           //|| teacherNavBar();
    );
  }
}




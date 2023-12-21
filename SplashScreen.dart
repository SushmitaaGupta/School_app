import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mydigischool/Login_&_Register/Login_Con.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home/Student_home/studentNavBar.dart';
import 'Home/Teacher_home/teacherNavBar.dart';


var LoginStudent;
var LoginTeacher;

getStudent() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  LoginStudent= sf.getString("student");
}

getTeacher() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  LoginTeacher= sf.getString("teacher");

}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    getStudent();
    getTeacher();
    startTimer(); // initializes the starttimer method..
  }


  //Created starttimer method having suration as 3 second after 3 second it moves to registration page.

  startTimer()async{
    var duration=const Duration(seconds: 2);
    return Timer(duration, route);
  }
  route(){

    LoginStudent == null && LoginTeacher != null ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>teacherNavBar())) : LoginStudent != null && LoginTeacher==null ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>studentNavBar())) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Con()));

   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login_Con()));
  }



  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
        gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 72,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/mydigilogo4.jpg",) ,
                    radius: 70,),
                ),

                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text("MyDigi School ", style: TextStyle(color: Colors.red, fontSize: 25, fontWeight: FontWeight.w400),),
                const Padding(padding: EdgeInsets.only(top: 20)),
                const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 1,
                )
              ],
            ),
          )

      ),
    );

  }
}

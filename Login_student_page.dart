import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mydigischool/Home/Teacher_home/teacherHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/Student_home/studentHome.dart';
import '../Home/Student_home/studentNavBar.dart';
import 'Login_Con.dart';
import 'package:http/http.dart' as http;


class Login_student_Page extends StatefulWidget {
  String? Student;
  Login_student_Page(this.Student);
  @override
  State<Login_student_Page> createState() => Login_student_Page_PageState();
}

/*var Logintype;
getlogintype() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  sf.getString("Logintype");
  Logintype= sf.getString("Logintype");
  print(Logintype);
}*/


class Login_student_Page_PageState extends State<Login_student_Page> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  void authenticate(String username, String pass) async {
      String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/loginApi/studentLogin";
      http.post(Uri.parse(myurl), headers: {
        'Accept': 'application/json'
      }, body: {
        "username": username.toString(),
        "password": pass.toString()
      }).then((response) async {
        Map mapRes = json.decode(response.body);
        if(mapRes['status'] == "success"){
          SharedPreferences sf = await SharedPreferences.getInstance();
          sf.setString("studentid", mapRes['studentId'].toString());
          sf.setString("isLogout", username.toString());
          sf.setString("student", widget.Student.toString());
          sf.setBool("loggedin", true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => studentNavBar()));
        }

        else{
          var snackBar = SnackBar(
              backgroundColor: Colors.grey.shade700,
              duration: const Duration(seconds: 2),
              content:
              Row(
                children: const [
                  Icon(Icons.error_outline, color: Colors.red,),
                  SizedBox(width: 5,),
                  Text("Invalid Username or Password", style: TextStyle(color: Colors.white),),
                ],
              )
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*print(Login_as);*/

  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/log.jpg"), fit: BoxFit.cover,opacity:0.8),
            gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 150),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 35),
                      )),
             /*     Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      )),*/
                  Container(
                    padding:  EdgeInsets.all(10),
                    child: TextField(
                      cursorColor: Colors.red,
                      controller: username,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide( color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(25)),),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide:  BorderSide( color: Colors.red)),
                        prefixIcon: Icon(Icons.person, color: Colors.red, size: 24),
                        labelText: 'User Name',
                        labelStyle: TextStyle(color: Colors.red),
                       /* hintText: "User Name",
                        hintStyle: TextStyle(color: Colors.grey),*/

                      ),
                    ),
                  ),
                  Container(
                    padding:  EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscured,
                      focusNode: textFieldFocusNode,
                      cursorColor: Colors.red,
                      controller: password,
                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide( color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(25)),),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide:  BorderSide( color: Colors.red)),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.red),
                        prefixIcon: Icon(Icons.lock_rounded, color: Colors.red, size: 24),
                       suffixIcon: Padding(
                       padding:  EdgeInsets.fromLTRB(0, 0, 4, 0),
                       child: GestureDetector(
                         onTap: _toggleObscured,
                           child:
                             _obscured
                                 ? Icon(Icons.visibility_rounded, size: 24, color: Colors.red,)
                                 : Icon(Icons.visibility_off, size: 24, color: Colors.grey,)


                       )
                      ),
                       /* hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),*/
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text('Forgot Password',style: TextStyle(color: Colors.red),),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, //background color of button
                            side: BorderSide(width:00, color:Colors.red), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),
                        child: const Text('Login'),
                        onPressed: () async {
                          authenticate(username.text,password.text);

                        },
                      )
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

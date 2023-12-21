import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mydigischool/Home/Teacher_home/teacherNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();
final textFieldFocusNode = FocusNode();
bool _obscured = true;

class login_teacher_page extends StatefulWidget {
  String? teacher;
  login_teacher_page(this.teacher);

  @override
  State<login_teacher_page> createState() => _login_teacher_pageState();
}

class _login_teacher_pageState extends State<login_teacher_page> {

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  void authenticate(String username, String pass) async {
    String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/loginApi/teacherLogin";
    http.post(Uri.parse(myurl), headers: {
      'Accept': 'application/json'
    }, body: {
      "username": username.toString(),
      "password": pass.toString()
    }).then((response) async {
      Map mapRes = json.decode(response.body);
      print(response.body);
      if(mapRes['status'] == "success"){
        print(response.body);
        SharedPreferences sf = await SharedPreferences.getInstance();
        sf.setString("teacherid", mapRes['teacherId'].toString());
        sf.setString("teacher", widget.teacher.toString());
        sf.setString("isLogout1", username.toString());
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (context) => teacherNavBar()));
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

                           // Navigator.push(context, MaterialPageRoute(builder: (context)=>teacherNavBar()));
                          }
                      )
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

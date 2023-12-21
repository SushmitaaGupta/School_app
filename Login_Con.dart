import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Students/Stud_regis.dart';
import 'Login_student_page.dart';
import 'Login_teacher_page.dart';
import 'Register_Con.dart';

class Login_Con extends StatefulWidget {
  const Login_Con({super.key});

  @override
  State<Login_Con> createState() => _Login_ConState();
}

class _Login_ConState extends State<Login_Con> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/log2.jpg"), fit: BoxFit.cover,opacity: 1),
            gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
          child: Center(
            child: Column(
              children: [
                ////Logo.................
                SizedBox(height: 200,),
                Container(
                  padding: const EdgeInsets.all(8.0),

                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       CircleAvatar(
                        backgroundImage: AssetImage("assets/mydigilogo4.jpg",) ,
                         radius: 50,)
                          // child: Image(image: AssetImage("assets/mydigilogo1.jpg",),width: 270,height: 110,)),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                const Text("Login here", style: TextStyle(fontWeight: FontWeight.w500,color: Colors.deepOrange, fontSize: 20),),
                const SizedBox(height: 10,),
                const Text("Please Select the type of Login here."),
                SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                  Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: ()async{

                        Navigator.push
                          (context, MaterialPageRoute(builder: (context)=> login_teacher_page("Teacher")));
                      },
                      child: Container(
                        width: 230,
                        height: 45,
                        child: Card(
                            color: Color(0xffC21807),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: const Center(child: Text('Login As Teacher',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    InkWell(
                         onTap: () async {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Login_student_Page("Student")));
                      },
                      child: Container(
                        width: 230,
                        height: 45,
                        child: Card(
                          color:Color(0xffC21807),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child:  const Center(child: Text('Login As Student',textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an acoount"),
                        TextButton(
                            onPressed:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Register_Con()));
                            } ,
                            child: Text("Sign Up",style: TextStyle(fontSize: 16,color: Colors.white,),))
                      ],
                    )


                  ],
                ),
              ),

               /* InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Stud_regis()));
                  },
                  child: Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CircleAvatar(radius:60,backgroundColor: Colors.white, backgroundImage: AssetImage("assets/teacher1.jpg")),
                      SizedBox(width: 10,),
                      Container(
                          padding: EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                          child: Text("As Techer", style: TextStyle(color: Colors.white),)),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //CircleAvatar(radius:60,backgroundColor: Colors.white, backgroundImage: AssetImage("assets/student1.jpg"),),

                    Container(

                        padding: EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                        child: Text("As Student", style: TextStyle(color: Colors.white),)),
                  ],
                ),*/
              ],
            ),
          )

      ),
    );
  }
}

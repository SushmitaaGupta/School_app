import 'package:flutter/material.dart';
import 'package:mydigischool/Students/Stud_regis.dart';
import '../Teachers/Teaches_resgis.dart';
import '../Regi1.dart';

class Register_Con extends StatefulWidget {
  const Register_Con({Key? key}) : super(key: key);

  @override
  State<Register_Con> createState() => _Register_ConState();
}

class _Register_ConState extends State<Register_Con> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/log3.jpg"), fit: BoxFit.cover,opacity:0.8),
            gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 70,),
              ////Logo.................
              Container(
                padding: const EdgeInsets.all(8.0),

                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                     CircleAvatar(
                       backgroundImage: AssetImage("assets/mydigilogo4.jpg",) ,
                       radius: 50,)
                  ],
                ),
              ),
              SizedBox(height: 30,),
              const Text("Register here", style: TextStyle(fontWeight: FontWeight.w500,color: Colors.orange, fontSize: 20),),
              const SizedBox(height: 10,),
              const Text("Please Select the type of Login here."),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),

            /*  Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        //Login_As ="Owner";
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Stud_regis(
                         // Login_As: Login_As.toString(),
                        )));
                      },
                      child: Container(
                        width: 230,
                        height: 45,
                        child: Card(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: const Center(child: Text('Login As Teacher',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    InkWell(
                         onTap: (){
                        //Login_As="Tenant";
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Stud_regis(
                         // Login_As: Login_As.toString(),

                        )));
                      },
                      child: Container(
                        width: 230,
                        height: 45,
                        child: Card(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child:  const Center(child: Text('Login As Student',textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),

                  ],
                ),
              ),*/

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Teaches_regis()));
                },
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius:60,backgroundColor: Colors.white, backgroundImage: AssetImage("assets/teacher2.jpeg")),
                    SizedBox(width: 10,),
                    Container(
                      padding: EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(color: Color(0xffC21807), borderRadius: BorderRadius.circular(20)),
                        child: Text("As Techer", style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Stud_regis()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius:60,backgroundColor: Colors.white, backgroundImage: AssetImage("assets/boy.jpeg"),),
                    SizedBox(width: 10,),
                    Container(
                        padding: EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(color: Color(0xffC21807), borderRadius: BorderRadius.circular(20)),
                        child: Text("As Student", style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

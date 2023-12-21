import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mydigischool/Home/Student_home/studentassignmenttemp.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'DailyActivity.dart';
import 'Notice.dart';
import 'complaint.dart';
import 'dosanddonts.dart';
import 'healtyhabits.dart';


class studentHome extends StatefulWidget {
  const studentHome({Key? key}) : super(key: key);

  @override
  State<studentHome> createState() => _studentHomeState();
}
List jsonResponse=[];



class today_quotes {
  String schoolId;
  String quoteId;
  String quotes;

  today_quotes({
    required this.schoolId,
    required this.quoteId,
    required this.quotes,

  });

  factory today_quotes.fromJson(Map<String, dynamic> json) {
    return today_quotes(
      schoolId: json['schoolId'],
      quoteId: json['quoteId'],
      quotes: json['quotes'],

    );
  }
}

Future<List<today_quotes>> today_quotes_API() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  var url = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/quotesDetailApi/get_today_quotes";
  Map mapdata = {
    "school_id": sf.getString("schoolId").toString()
  };
  http.Response response = await http.post(Uri.parse(url),body: mapdata);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body)["quoteList"];
    print("Quotes");
    print(jsonResponse);
    return jsonResponse.map((data) => today_quotes.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}


class DailySubjects{
  String? classId;
  String? schoolId;
  String? subjectId;
  String? subjectName;

  DailySubjects({this.classId, this.schoolId, this.subjectId, this.subjectName});

  factory DailySubjects.fromJson(Map<String, dynamic> json){
    return DailySubjects(
      classId: json['p_id'],
      schoolId: json['schoolId'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],

    );
  }
}

Future<List<DailySubjects>> DailySubjectsAPI() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  String myurl =  "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/schoolDetailApi/subject_detail";
  return http.post(Uri.parse(myurl), body: {
    'class_id': sf.getString("classId").toString(),
  }).then((response) {
    if(response.statusCode==200) {
      List jsonResponse = json.decode(response.body)['subjectList'];
      sf.setString("subjectId", jsonResponse[0]['subjectId'].toString());
      print("Dailysubject");
      print(jsonResponse);
      return jsonResponse.map((data) => DailySubjects.fromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occurred! in maincategory');
    }

  });
}

final List<String> imgList = [
  'assets/slider1.jpg',
  'assets/slider2.jpg',
  'assets/slider3.jpg',

];


class _studentHomeState extends State<studentHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    today_quotes_API();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
        gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              FutureBuilder<List<today_quotes>>(
                  future: today_quotes_API(),
                  builder: (context, snapshot) {
                    print("TEXT");
                    List<today_quotes>? data = snapshot.data;
                    print(data);
                    if (snapshot.hasData) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff0B6E4F),
                                  Colors.grey.shade400,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, top: 8.0,),
                                child: Row(
                                  children: [
                                    Text("Quote of the day!", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                                  ],
                                ),
                              ),
                               ListTile(
                                title: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(jsonResponse[0]['quotes'].toString(),style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff0B6E4F),
                                  Colors.grey.shade400,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, top: 8.0,),
                                child: Row(
                                  children: [
                                    Text("Quote of the day!", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Education is the most powerful weapon you can use to change the world.",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    }
                  }),
              SizedBox(height: 5,),
              //circle section//

              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children:  [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>do_Does()));
                          },
                          child: CircleAvatar(
                            radius: 41,
                            backgroundColor: Colors.amber,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/doesanddont.jpg'),
                            ),
                          ),
                        ),
                        SizedBox(height: 2,),
                        Text("Do's & Don't", style: TextStyle(color:Color(0xffE8a317),fontWeight : FontWeight.w400 ,fontFeatures: [FontFeature.enable('smcp')]))
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children:  [
                        InkWell(
                          onTap:() {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Healtyhabits()));
                          },
                          child: CircleAvatar(
                            radius: 41,
                            backgroundColor: Colors.amber,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/healthy.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 2,),
                        Text("Healthy Habits", style: TextStyle(color: Color(0xffE8a317),fontWeight : FontWeight.w400 ,fontFeatures: [FontFeature.enable('smcp')]),)
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: const [
                        CircleAvatar(
                          radius: 41,
                          backgroundColor: Colors.amber,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/livelectures.jpg'),
                          ),
                        ),
                        SizedBox(height: 2,),
                        Text("Recorded lecture", style: TextStyle(color:Color(0xffE8a317),fontWeight : FontWeight.w400 ,fontFeatures: [FontFeature.enable('smcp')]),)
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children:  [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 41,
                              backgroundColor: Colors.amber,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/logicbox2.png'),
                              ),
                            ),
                            SizedBox(
                              width: 80, height: 83,
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                                strokeWidth: 3,

                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 2,),
                        Text("Logic Box", style: TextStyle(color: Color(0xffE8a317),fontWeight : FontWeight.w400 ,fontFeatures: [FontFeature.enable('smcp')]),)
                      ],),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>s_Feedback()));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              height: 150,width: MediaQuery.of(context).size.width/2.2,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),)),
                                elevation: 10,
                                color: Color(0xff641975),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0, left: 10, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Text("Achievements", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),)),
                                          SizedBox(width: 2,),
                                          Icon(Icons.grade, color: Colors.white,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Good", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),),
                                          SizedBox(width: 5,),
                                          CircularPercentIndicator(radius: 10,
                                            lineWidth: 4.0,
                                            percent: 0.70,

                                            progressColor: Colors.amber,

                                          )
                                        ],
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child:Image.asset("assets/achievement.png", height: 80,)
                          ),

                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Healtyhabits()));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              height: 150,width: MediaQuery.of(context).size.width/2.2,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),)),
                                elevation: 10,
                                color: Color(0xff4B0082),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0, left: 10, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Progress Report", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                                          SizedBox(width: 3,),
                                          Icon(Icons.bar_chart, color: Colors.white,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text("See your  progress report here!", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w400),)),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width/4.3),
                            child: Container(
                              height: 90,
                              color: Colors.transparent,
                              child: Image.asset("assets/progress2.png"),
                            )
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [



                    InkWell(
                      onTap: (){
                        /*Navigator.push(context, MaterialPageRoute(builder: (context)=>StudyMaterial()));*/
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              height: 150,width: MediaQuery.of(context).size.width/2.1,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),)),
                                elevation: 10,
                                color: Color(0xff125488),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:50.0, left: 10, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Study Material", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),),
                                          SizedBox(width: 5,),
                                          CircleAvatar( radius:10, backgroundColor:Color(0xff125488) , child: Icon(size: 20, Icons.edit, color:Colors.white,),)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Its time to study...",style: TextStyle(color: Colors.yellow,)),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius:50, backgroundImage: AssetImage("assets/dragon.png"),),
                          ),

                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>studentAssignment()));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              height: 150,width: MediaQuery.of(context).size.width/2.1,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),)),
                                elevation: 10,
                                color: Colors.green[900],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0, left: 10, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Assignment", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                                          SizedBox(width: 3,),
                                          Icon(Icons.menu_book, color: Colors.white,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Are you ready ?", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w400),),
                                          SizedBox(width: 5,),
                                          CircularPercentIndicator(radius: 10,
                                            lineWidth: 4.0,
                                            percent: 0.75,

                                            progressColor: Colors.yellow,

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                              padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width/4.3),
                              child: Container(
                                height: 90,
                                color: Colors.transparent,
                                child: Image.asset("assets/dragon3.png"),
                              )
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>S_Compaint()));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              height: 150,width: MediaQuery.of(context).size.width/2.1,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),)),
                                elevation: 10,
                                color: Color(0xffE8a317),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0, left: 10, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Complaint", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                                          SizedBox(width: 3,),
                                          Icon(Icons.bar_chart, color: Colors.white,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Want to raise ?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          SizedBox(width: 5,),
                                          CircularPercentIndicator(radius: 10,
                                            lineWidth: 4.0,
                                            percent: 0.70,

                                            progressColor: Colors.white,

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius:50, backgroundImage: AssetImage("assets/pikachu.png"),),
                          ),

                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>noticeBord()));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                              height: 150,width: MediaQuery.of(context).size.width/2.2,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),)),
                                elevation: 10,
                                color: Color(0xffFD6A02),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0, left: 10, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Notice", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                                          SizedBox(width: 3,),
                                          Icon(Icons.book, color: Colors.white,)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("No Notice Today!", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w400),),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width/5),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius:50, backgroundImage: AssetImage("assets/cat.png"),),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height:10),
              Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),)),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xffB43757),
                        Colors.pink.shade300
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  SizedBox(height:10),
                  ListTile(
                    title: Text("Bus Tracking",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                    trailing: IconButton(icon:Icon(Icons.airline_stops,color: Colors.white,),onPressed: (){},),
                    subtitle:Text("Coming soon...",style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.w700),),
                  ),

                  SizedBox(height:10),

                ]

            )),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text("Todays Activity", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                  ],
                ),
              ),
              FutureBuilder(

                  future: DailySubjectsAPI(),
                  builder: (context, snapshot){
                    List<DailySubjects>? data= snapshot.data;
                    if(snapshot.hasData){
                      return Container(
                        height: MediaQuery.of(context).size.height/3,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async{
                                SharedPreferences sf = await SharedPreferences.getInstance();
                                sf.setString("subjectId",data[index].subjectId.toString());
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyStudentActivity()));
                              },
                              child: Container(
                                height: 100,
                                child: Card(
                                  color: Color(0xfff0e68c),
                                  elevation: 0,
                                  child: ListTile(
                                    leading: Stack(
                                      children: [
                                        Image.asset("assets/junglebook.jpg", fit: BoxFit.cover,),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 13.0, top: 18),
                                          child: Icon(Icons.play_arrow, color: Colors.white,),
                                        )
                                      ],
                                    ),
                                    title:  Text(data[index].subjectName.toString(), style: TextStyle(color: Colors.red),),
                                    subtitle: Text("The story About two mouse"),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Container();

                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/play.png", height: 18,),
                    // Container(
                    //     padding: const EdgeInsets.all(8.0),
                    //     decoration: BoxDecoration(
                    //       color: Colors.red,
                    //     borderRadius: BorderRadius.circular(10)),
                    //     child: Text("Let's Play", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w500),)),
                  ],
                ),
              ),

              //Carousal Slider
              Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      viewportFraction: 1,
                      aspectRatio: 15 / 9,
                    ),
                    items: imgList
                        .map((item) =>  Container(
                      color: Colors.transparent,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>''));
                        },
                        child: Card(
                          child: Image.asset(item.toString()),
                        ),
                      ),
                    ))
                        .toList(),
                  )),

            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class do_Does extends StatefulWidget {
  const do_Does({super.key});

  @override
  State<do_Does> createState() => _do_DoesState();
}

class doDode{
  String? doanddont;
  String? do_id;
  String? type;
  String? school_id;

  doDode({this.doanddont, this.do_id,this.type ,this.school_id  });

  factory doDode.fromJson(Map<String, dynamic> json){
    return doDode(
        doanddont: json['doanddont'],
        do_id: json['do_id'],
        type: json['type'],
        school_id: json['school_id']
    );
  }
}

class Health_habit{
  String? healthyHabitId;
  String? healthyHabitDetail;
  String? school_id;

  Health_habit({this.healthyHabitId, this.healthyHabitDetail ,this.school_id  });

  factory Health_habit.fromJson(Map<String, dynamic> json){
    return Health_habit(
        healthyHabitId: json['healthyHabitId'],
        healthyHabitDetail: json['healthyHabitDetail'],
        school_id: json['school_id']
    );
  }
}

class _do_DoesState extends State<do_Does> {

  Future<List<doDode>> do_DoesApi() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/DoDontApi/get_do_dont";
    return http.post(Uri.parse(myurl), body: {
      "school_id": sf.getString("schoolId").toString(),
    }).then((response) {
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['doList'];
        return jsonResponse.map((data) => doDode.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected error occurred!');
      }
    });
  }

  Future<List<doDode>> dont_DoesApi() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/DoDontApi/get_do_dont";
    return http.post(Uri.parse(myurl), body: {
      "school_id": sf.getString("schoolId").toString(),
    }).then((response) {
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['dontList'];
        return jsonResponse.map((data) => doDode.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected error occurred!');
      }
    });
  }



  Future<List<Health_habit>> Health_habitapi() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/healthyHabitApi/get_healthy_habit";
    return http.post(Uri.parse(myurl), body: {
      "school_id": sf.getString("schoolId").toString(),
    }).then((response) {
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['healthyHabitList'];
        return jsonResponse.map((data) => Health_habit.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected error occurred!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDFCFB),
      appBar: AppBar(backgroundColor: Colors.deepOrangeAccent,title: Text("Do's & Dont's")),
      body: SingleChildScrollView(
        child:Column(

          children: [
            SizedBox(height:0),
            Container(
                color: Colors.white,
              width: MediaQuery.of(context).size.width,
            child : Card(

             elevation: 10,
             color: Colors.white,
            child: Padding(padding:EdgeInsets.only(top: 15,bottom: 15),child: Center(child : Text("Do's",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w500,fontSize:20, fontFeatures: [FontFeature.enable('smcp')])))),
            )),

            FutureBuilder<List<doDode>>(
                future:do_DoesApi() ,
                builder:(context, snapshot) {
                  List<doDode>? data = snapshot.data;
                  if(snapshot.hasData){

                  return
                  ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data!.length,
                  itemBuilder: (context,index){

                    return ListTile(
                    leading : Icon(Icons.check,color:Colors.green,size:30),
                    trailing: Icon(Icons.campaign_outlined ,color:Colors.green,size:30),
                    title: Text("${data[index].doanddont.toString()}",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),

                    );


                  }, separatorBuilder: (BuildContext context, int index) { return Divider(color: Colors.grey,
                  thickness: 1,); },);
                  }
                  else{}
                  return CircularProgressIndicator();
                }
            ),
            //end of dos//

            //start of donts//
            SizedBox(height:20),
            Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child : Card(

                  elevation: 10,
                  color: Colors.white,
                  child: Padding(padding:EdgeInsets.only(top: 15,bottom: 15),child: Center(child : Text("Dont's",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w500,fontSize:20, fontFeatures: [FontFeature.enable('smcp')])))),
                )),

            FutureBuilder<List<doDode>>(
                future:dont_DoesApi() ,
                builder:(context, snapshot) {
                  List<doDode>? data = snapshot.data;
                  if(snapshot.hasData){

                  return
                  ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data!.length,
                  itemBuilder: (context,index){

                  return ListTile(
                  leading : Icon(Icons.clear,color:Colors.red,size:30),
                  trailing: Icon(Icons.campaign_outlined ,color:Colors.red,size:30),
                  title: Text("${data[index].doanddont.toString()}",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),

                  );


                  }, separatorBuilder: (BuildContext context, int index) { return Divider(color: Colors.grey,
                  thickness: 1,); },);
                  }
                  else{}
                  return Container();
                }
            ),




           /* FutureBuilder<List<Health_habit>>(
                future:Health_habitapi() ,
                builder:(context, snapshot) {
                  List<Health_habit>? data = snapshot.data;
                  if(snapshot.hasData){
                  print(data![0].healthyHabitId.toString());
                  return
                  ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context,index){
                  for(int i= index; i<=data.length; i++){
                  // srn_no.add(i);
                  print(i);
                  }
                  return Column(
                  children: [
                  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                  Text("${data[index].healthyHabitId.toString()}",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  Text("${data[index].healthyHabitDetail.toString()}",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  Text("${data[index].school_id.toString()}",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                  ],
                  ),
                  ),

                  Divider(
                  color: Colors.black,
                  thickness: 1,
                  )

                  ],
                  );


                  });
                  }
                  else{}
                  return Container();
                }
            ),*/
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Healtyhabits extends StatefulWidget {
  const Healtyhabits({super.key});

  @override
  State<Healtyhabits> createState() => HealtyhabitsState();
}


class Health_habit{
  String? healthyHabitId;
  String? healthyHabitDetail;
  String? schoolId;

  Health_habit({this.healthyHabitId, this.healthyHabitDetail ,this.schoolId  });

  factory Health_habit.fromJson(Map<String, dynamic> json){
    return Health_habit(
        healthyHabitId: json['healthyHabitId'],
        healthyHabitDetail: json['healthyHabitDetail'],
        schoolId: json['schoolId']
    );
  }
}

class HealtyhabitsState extends State<Healtyhabits> {




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
      appBar: AppBar(backgroundColor: Colors.deepOrangeAccent,title: Text("Healthy Habits")),
      body: SingleChildScrollView(
        child:Column(
          children: [

            Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child : Card(

                  elevation: 10,
                  color: Colors.white,
                  child: Padding(padding:EdgeInsets.only(top: 15,bottom: 15),child: Center(child : Text("Healthy Habits",style: TextStyle(color: Colors.red,fontWeight:FontWeight.w500,fontSize:20, fontFeatures: [FontFeature.enable('smcp')])))),
                )),

            FutureBuilder<List<Health_habit>>(
                future:Health_habitapi() ,
                builder:(context, snapshot) {
                  List<Health_habit>? data = snapshot.data;
                  if(snapshot.hasData){

                  return
                  ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data!.length,
                  itemBuilder: (context,index){

                  return ListTile(
                  leading : Icon(Icons.thumb_up,color:Colors.deepOrangeAccent,size:30),
                  trailing: Icon(Icons.campaign_outlined ,color:Colors.deepOrangeAccent,size:30),
                  title: Text("${data[index].healthyHabitDetail.toString()}",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),

                  );






                  }, separatorBuilder: (BuildContext context, int index) {  return Divider(color: Colors.grey,
                  thickness: 1,); },);
                  }
                  else{}
                  return CircularProgressIndicator();
                }
            ),
          ],
        ),
      ),
    );
  }
}
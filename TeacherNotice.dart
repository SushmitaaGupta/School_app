import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class TeachernoticeBord extends StatefulWidget {
  const TeachernoticeBord({super.key});

  @override
  State<TeachernoticeBord> createState() => _TeachernoticeBordState();
}
//List jsonResponse=[];

class NoticeList {
  String schoolId;
  String publised_on;
  String valid_till;
  String notice_detail;

  NoticeList({
    required this.schoolId,
    required this.publised_on,
    required this.valid_till,
    required this.notice_detail

  });

  factory NoticeList.fromJson(Map<String, dynamic> json) {
    return NoticeList(
      schoolId: json['schoolId'],
      publised_on: json['publised_on'],
      valid_till: json['valid_till'],
      notice_detail: json['notice_detail'],
    );
  }
}



class _TeachernoticeBordState extends State<TeachernoticeBord> {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
  Future<List<NoticeList>>? noticelist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //noticelist= getNoticeDetail_API();
    print(noticelist);
  }

  Future<List<NoticeList>> NoticeList_api() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    print("Chekc Teacher Id");
    print(sf.getString("TSchoolid").toString(),);
    var url ="http://103.148.157.74:33178/DigiSchoolWebAppNew/android/noticeDetailApi/getNoticeDetail";
    Map mapdata = {
      "school_id": sf.getString("TSchoolid").toString(),
      "individual_id":sf.getString("studentId").toString(),
      "individual_is": "Teacher"
    };
    http.Response response = await http.post(Uri.parse(url),body: mapdata);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)["noticeList"];
      /* print("notice");
      print(jsonResponse);
      print(jsonResponse[0]["valid_till"]);
      print(jsonResponse[0]["title"]);*/
      return jsonResponse.map((data) => NoticeList.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Notice'),
      ),
      body:  Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
        height:MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: NoticeList_api(),
            builder: (context, snapshot){
              List<NoticeList>? data = snapshot.data;
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index){
                      return  Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Publish Date:",
                                      style:TextStyle( color:Colors.deepOrangeAccent, fontWeight: FontWeight.w500,fontSize: 15) ,),
                                    Text(" ${data[index].publised_on.toString()}",
                                      style:TextStyle( color:Colors.deepOrangeAccent, fontWeight: FontWeight.w500,fontSize: 15) ,)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Till:",
                                        style:TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w500,fontSize: 15)),
                                    Text(" ${data[index].valid_till.toString()}",
                                        style:TextStyle( color:Colors.deepOrangeAccent,fontWeight: FontWeight.w500,fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text("Notice",style: TextStyle(color:Colors.deepOrangeAccent,fontSize: 15,fontWeight: FontWeight.w500),),
                                    SizedBox(height: 5,),
                                    Text(_parseHtmlString(
                                        " ${data[index].notice_detail}"),
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                              ),),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.deepOrangeAccent,
                          )
                        ],
                      );
                    });
              }
              return Container();
            }),
      ),
    );
  }
}

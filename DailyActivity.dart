import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Videoshow/videobox.dart';


String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString =
      parse(document.body!.text).documentElement!.text;
  return parsedString;
}


class GetActivityData {
  String chapter;
  String teacherName;
  List resourceList;
  String resources;
  String className;
  String sectionId;
  String createdOn;
  String subjectId;
  String objective;
  String sectionName;
  String activityId;
  String assessment;
  String classId;
  String teacherId;
  String schoolId;
  String topic;
  String subjectName;


  GetActivityData(
      {required this.chapter,
        required this.teacherName,
        required this.resourceList,
        required this.resources,
        required this.className,
        required this.sectionId,
        required this.createdOn,
        required this.subjectId,
        required this.objective,
        required this.sectionName,
        required this.activityId,
        required this.assessment,
        required this.classId,
        required this.teacherId,
        required this.schoolId,
        required this.topic,
        required this.subjectName
      });

  factory GetActivityData.fromJson(Map<String, dynamic> json) {
    return GetActivityData(
      chapter: json['chapter'],
      teacherName: json['teacherName'],
      resourceList: json['resourceList'],
      resources: json['resources'],
      className: json['className'],
      sectionId: json['sectionId'],
      createdOn: json['createdOn'],
      subjectId: json['subjectId'],
      objective: json['objective'],
      sectionName: json['sectionName'],
      activityId: json['activityId'],
      assessment: json['assessment'],
      classId: json['classId'],
      teacherId: json['teacherId'],
      schoolId: json['schoolId'],
      topic: json['topic'],
      subjectName: json['subjectName'],
    );
  }
}

Future<List<GetActivityData>> getAllActivity() async {
  SharedPreferences sf = await SharedPreferences.getInstance();
  //print(sf.getString("classId").toString());
  String myurl = "http://103.148.157.74:33178/DigiSchoolWebAppNew/android/dailyActivityDetailApi/get_today_activity_detail";
  return http.post(Uri.parse(myurl), body: {
    'school_id':sf.getString("schoolId").toString(),
    'class_id':sf.getString("classId").toString(),
    'section_id':sf.getString("sectionId").toString(),
    'subject_id':sf.getString("subjectId").toString(),

  }).then((response) {
    print(response.statusCode);
    if (response.statusCode == 200) {
      // print("helo");

      List jsonResponse = json.decode(response.body)['activityList'];
      print(jsonResponse);

      return jsonResponse.map((data) => GetActivityData.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  });
}

class DailyStudentActivity extends StatefulWidget {
  const DailyStudentActivity({super.key});

  @override
  State<DailyStudentActivity> createState() => _DailyStudentActivityState();
}


class _DailyStudentActivityState extends State<DailyStudentActivity> {


  int progress = 0;
  ReceivePort _receivePort = ReceivePort();
  var dio = Dio();

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {}
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }


  @override
  void initState() {
    // TODO: implement initState
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");
    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadingCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            title: Text("DailyActivity"),
            elevation: 0,
            leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            //automaticallyImplyLeading: false,
          ),
          body: Container(
            decoration: const BoxDecoration(
              //image: DecorationImage(image: AssetImage("assets/bgimage.jpg"), fit: BoxFit.cover,opacity: 0.15),
              gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),),
            height:MediaQuery.of(context).size.height,
           // width:MediaQuery.of(context).size.width,
            child: Center(child : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child : FutureBuilder(
                  future: getAllActivity(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      // print("working");
                      var data = snapshot.data;
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data!.length,
                          itemBuilder:(context,index) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children : [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(colors: [Color(0xffFDFCFB), Color(0xffE2D1C3)]),
                                        border: Border.all(color: Colors.black,
                                            width: 1.0, style: BorderStyle.solid
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Teacher Name",
                                                      style: TextStyle( color:Colors.deepOrangeAccent,fontWeight: FontWeight.w600, fontSize: 18),),
                                                    SizedBox(height: 7,),
                                                    Text(data[index].teacherName.toString(),
                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),)
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text("Subject",
                                                        style: TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w600, fontSize: 18)),
                                                    SizedBox(height: 7,),
                                                    Text(data[index].subjectName.toString(),
                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                                                  ],
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10,),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Topic",
                                                        style: TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w600, fontSize: 18)),
                                                    SizedBox(height: 7,),

                                                    Text(_parseHtmlString (data[index].topic.toString(),),
                                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17),),
                                                  ],
                                                ),

                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10,),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Chapter",
                                                        style: TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w600, fontSize: 18)),
                                                    SizedBox(height: 7,),
                                                    Text(data[index].chapter.toString(),
                                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)),
                                                  ],


                                            ),
                                            SizedBox(height: 10,),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10,),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Objective",
                                                        style: TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w600, fontSize: 18)),
                                                    SizedBox(height: 7,),
                                                    Text(data[index].objective.toString(),
                                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)),
                                                  ],


                                            ),
                                            SizedBox(height: 10,),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10,),


                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(_parseHtmlString("Resources"),
                                                        textAlign: TextAlign.justify,
                                                        style: TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w500, fontSize: 17)
                                                    ),
                                                    SizedBox(height: 7,),
                                                    Text(_parseHtmlString( " ${data[index].resources.toString()}"),
                                                        textAlign: TextAlign.justify,
                                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)
                                                    ),
                                                  ],


                                            ),

                                            SizedBox(height: 10,),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(_parseHtmlString("Assessment"),
                                                          textAlign: TextAlign.justify,
                                                          style: TextStyle(color:Colors.deepOrangeAccent,fontWeight: FontWeight.w500, fontSize: 17)
                                                      ),
                                                      SizedBox(height: 7,),
                                                      Text(_parseHtmlString(" ${data[index].assessment.toString()}"),
                                                          textAlign: TextAlign.justify,
                                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17)
                                                      ),
                                                    ],
                                                  ),




                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data[index].resourceList.length,
                                      itemBuilder: (context, i) {
                                        // print(l[index].resourceList[i]['resourceFilePath'].toString());
                                        return Padding(
                                            padding: EdgeInsets.only(left:10,right: 10,bottom: 0),
                                            child : Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              child: data[index].resourceList[i]['resourceType'] == "Video"?
                                              /*Text(l[index].resourceList[i]['resourceFilePath'].toString())*/
                                              videoBox("http://103.148.157.74:33178/DigiSchoolWebAppNew/"+ data[index].resourceList[i]['resourceFilePath'].toString()):

                                              //Pdf file logic//
                                              data[index].resourceList[i]['resourceType'] == "Pdf"?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(data[index].resourceList[i]['resourceFileName'].toString(),
                                                    style:TextStyle(fontWeight: FontWeight.w500,fontSize: 15) ,),
                                                  SizedBox(width: 15,),
                                                  IconButton(onPressed: () async{
                                                    String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                                                    if (path.isNotEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, backgroundColor: Colors.black, content: Text("Downloading...")));
                                                      final externalDir = await getExternalStorageDirectory();
                                                      String fullPath = "$path/" + data[index].resourceList[i]['resourceFileName'].toString();
                                                      download2(dio, "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString(), fullPath);
                                                      await FlutterDownloader.enqueue(url:  "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString(),
                                                        savedDir: externalDir!.path,
                                                        fileName: data[index].resourceList[i]['resourceFileName'].toString(),
                                                        showNotification: true,
                                                        openFileFromNotification: true,
                                                      );
                                                    } else {}

                                                  },
                                                    icon: const Icon(Icons.download,color: Colors.deepOrange,),

                                                  ),

                                                ],
                                              ):

                                              //Doc file logic//
                                              data[index].resourceList[i]['resourceType'] == "Doc"?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(data[index].resourceList[i]['resourceFileName'].toString(),
                                                      style:TextStyle(fontWeight: FontWeight.w500,fontSize: 15)),
                                                  SizedBox(width: 15,),
                                                  IconButton(onPressed: () async{
                                                    String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                                                    if (path.isNotEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, backgroundColor: Colors.black, content: Text("Downloading...")));
                                                      final externalDir = await getExternalStorageDirectory();

                                                      String fullPath = "$path/" + data[index].resourceList[i]['resourceFileName'].toString();

                                                      download2(dio,
                                                          "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString(),
                                                          fullPath);
                                                      await FlutterDownloader
                                                          .enqueue(
                                                        url:  "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString(),
                                                        savedDir: externalDir!.path,
                                                        fileName: data[index].resourceList[i]['resourceFileName'].toString(),
                                                        showNotification:
                                                        true,
                                                        openFileFromNotification:
                                                        true,
                                                      );
                                                    } else {}
                                                  },
                                                    icon: const Icon(Icons.download, color: Colors.deepOrange,),
                                                  ),
                                                ],
                                              ):

                                              //ppt file//
                                              data[index].resourceList[i]['resourceType'] == "Ppt"?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(data[index].resourceList[i]['resourceFileName'].toString(),
                                                      style:TextStyle(fontWeight: FontWeight.w500,fontSize: 15)),
                                                  SizedBox(width: 15,),
                                                  IconButton(onPressed: () async{
                                                    String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                                                    if (path.isNotEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, backgroundColor: Colors.black, content: Text("Downloading...")));
                                                      final externalDir = await getExternalStorageDirectory();
                                                      String fullPath = "$path/" + data[index].resourceList[i]['resourceFileName'].toString();
                                                      download2(dio,
                                                          "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString(),
                                                          fullPath);
                                                      await FlutterDownloader
                                                          .enqueue(
                                                        url:  "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString(),
                                                        savedDir: externalDir!.path,
                                                        fileName: data[index].resourceList[i]['resourceFileName'].toString(),
                                                        showNotification:
                                                        true,
                                                        openFileFromNotification:
                                                        true,
                                                      );
                                                    } else {}
                                                  },
                                                    icon: const Icon(Icons.download,color: Colors.deepOrange,),
                                                  ),
                                                ],
                                              ):

                                              //Link file//
                                              data[index].resourceList[i]['resourceType'] == "Link"?
                                              Padding(
                                                  padding: const EdgeInsets.all(15),
                                                  child: DefaultTextStyle(
                                                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                         Text('Click Link: '),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          child:  Text(
                                                              data[index].resourceList[i]['resourceFileName'].toString(),
                                                            style: const TextStyle(
                                                                color: Colors.blue, decoration: TextDecoration.underline),
                                                          ),
                                                          onTap: () async {
                                                            try {
                                                              await launch( "http://103.148.157.74:33178/DigiSchoolWebAppNew/" + data[index].resourceList[i]['resourceFilePath'].toString());
                                                            } catch (err) {
                                                              debugPrint('Something bad happened');
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              )
                                                  : Text("No Data Found"),
                                            )
                                        );
                                      }
                                  ),
                                ]
                            );
                          });
                    }
                    return Align(
                      alignment: Alignment.center,
                      child : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children : [
                          Text("No Activity for today !!!",textAlign: TextAlign.center)

                        ]
                      ),
                    );
                  }

              ),

            ),
          ),),
      //|| teacherNavBar();
    );
  }
}
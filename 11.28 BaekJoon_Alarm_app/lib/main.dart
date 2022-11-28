import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String handle;
  final int solvedCount;
  final int tier;

  User({required this.handle, required this.solvedCount, required this.tier});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      handle: json['handle'],
      solvedCount: json['solvedCount'],
      tier: json['tier'],
    );
  }
}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  late Future<User> user;
  final tec = TextEditingController();

  @override
  void initState() {
    super.initState();
    //user = getJSONData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baekjoon Alarm App"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children : <Widget>[
          Flexible(
            child: TextField(
              onChanged: (text){
                print('첫번째 text: $text');
              },
              controller: tec,
              decoration :InputDecoration(
                hintText: 'Solved.ac 아이디를 입력해주세요',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              getJSONData();
            },
            child: Icon(Icons.search),
          ),
          /* SolvedCount()값을 출력하는 객체?
          FutureBuilder<User>(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.solvedCount.toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // 기본적으로 로딩 Spinner를 보여줍니다.
              return CircularProgressIndicator();
            },
          ),
           */
        ]
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //
      //   },
      //   child: Icon(Icons.search),
      // ),
    );
  }

  Future<String> getJSONData() async{
    var url = 'https://solved.ac/api/v3/user/show?handle=${tec.value.text}';
    var response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json"});
    setState((){
      var dataConvertedToJSON = User.fromJson(json.decode(response.body));
      print(dataConvertedToJSON.solvedCount);
    });
    return "Successful";
  }
}

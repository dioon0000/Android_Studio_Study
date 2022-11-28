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
  TextEditingController? tec;

  @override
  void initState() {
    super.initState();
    user = getJSONData();
    tec = new TextEditingController(); // new 로 생성한 텍스트 에디터 컨트롤러
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
              print(tec?.text);
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
}

Future<User> getJSONData() async{
  var url = 'https://solved.ac/api/v3/user/show?handle=dioon0000}';
  var response = await http.get(Uri.parse(url),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    return User.fromJson(json.decode(response.body));
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}
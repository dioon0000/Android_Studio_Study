import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //http 패키지 불러오기
import 'dart:convert'; //JSON 데이터를 이용할 것이므로 convert 패키지 불러오기

/*
데이터 통신을 구현하기 위하여 서버와 데이터가 필요함
이 프로젝트에서 이용하려는 데이터는 책 정보로 카카오가 제공하는 검색 API 를 통하여 얻음
 */

// ! : 값이 null 이 아님
// ? : 값이 null 일 수 있음
// =>는 {return}과 동일한 기능
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); //키에 대한 이해 다시하기

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<HttpApp> createState() => _HttpApp(); // 다트 문법의 생명주기 부분 1단계 (처음 Stateful 을 시작할 때 호출)
}

class _HttpApp extends State<HttpApp> {
  String result = ''; //String 타입 변수 result
  List? data; //리스트 형태의 데이터 타입 변수 data (단, 값이 null 일 수도있음)
  TextEditingController? _editingController; //TextEditingController 타입의 클래스 _editingController (단, 값이 null 일 수도있음)
  ScrollController? _scrollController; //ScrollController 타입의 클래스 _scrollController (단, 값이 null 일 수도있음)
  int page = 1;

  @override
  void initState(){ // 다트 문법의 생명주기 부분 3단계 (State 에서 제일 먼저 실행되는 함수. State 생성 후 한 번만 호출)
    super.initState();
    //리스트 형태 변수
    data = new List.empty(growable: true);
    _editingController = new TextEditingController(); // new 로 생성한 텍스트 에디터 컨트롤러
    _scrollController = new ScrollController(); //new 로 생성한 스크롤 컨트롤러

    _scrollController!.addListener(() {
      // _scrollController!.offset 은 현재 위치를 double 형 변수로 나타냄 스크롤 할 때마다 maxScrollExtent 보다 크거나 같고,
      // 스크롤 컨트롤러의 position 에 정의된 범위를 넘어가지 않으면 목록의 마지막이라고 인식하여 page 를 1 증가 후 getJSONData() 함수 호출
      if(_scrollController!.offset >= _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange){
        print('bottom');
        page++;
        getJSONData();
      }
    });
  }

  @override
  Widget build(BuildContext context) { // 다트 문법의 생명주기 부분 5단계 (위젯을 렌더링하는 함수. 위젯을 반환)
    return Scaffold(
      appBar: AppBar(
        title: TextField( // title 에 TextField 를 넣고 컨트롤러와 스타일, 키보드 유형 등을 설정
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요'), // decoration 은 텍스트필드 위젯에 보이는 텍스트를 꾸미는 옵션, hintText 는 사용자에게 텍스트 필드에 무엇을 입력해야하는지 알려주는 역할
        ),
      ),
      body: Container(
        child: Center(
          /*
            data 가 0인지 아닌지 삼항연산자를 통하여
            참이면 Text('데이터가 없습니다.')를 TextStyle(fontSize: 20), textAlign.center 에 위치하도록 문구 표시
            거짓이면 (데이터가 존재한다면) ListView.builder로 표시하게 만듬
          */
          child: data!.length == 0
          ? const Text( // 참인 경우
            '데이터가 없습니다.',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          )
              : ListView.builder( // 거짓인 경우
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.network( // Image.network 는 네트워크에 있는 이미지를 가져오는 위젯
                        data![index]['thumbnail'], //data![index]['thumbnail']에서 가져온 URL 을 이용해 간단하게 화면에 이미지를 출력 가능
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      Column( //data 에서 JSON 키값에 해당하는 값을 화면에 출력
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 150, //MediaQuery.of(context).size 는 지금 스마트폰의 화면 크기를 의미
                            child: Text(
                              data![index]['title'].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text('저자 : ${data![index]['authors'].toString()}'),
                          Text('가격 : ${data![index]['sale_price'].toString()}'),
                          Text('판매중 : ${data![index]['status'].toString()}'),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: data!.length, // data 의 길이만큼 아이템의 개수를 지정
            controller: _scrollController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        page = 1;
        data!.clear();
        getJSONData(); //버튼을 누르면 getJSONData() 함수를 호출하도록 수정
      },
      child: Icon(Icons.search),
      ),
    );
  }

  /*
  Dart의 Future는 지금은 없지만 미래에 요청한 데이터 혹은 에러가 담길 그릇
  await : 키워드를 사용한 함수는 무조건 async 함수이어야 한다.
  async : 함수는 무조건 Future를 반환해야 한다.
  */
  Future<String> getJSONData() async{ //함수명() 뒤에 async 키워드를 붙이면 비동기 함수가 됨
    var url =
        //요청할 도메인. 카카오에서 책을 검색하는 API 를 나타냅니다.
        'https://dapi.kakao.com/v3/search/book?'
        //도메인에 요청할 target 파라미터에 title을 전달, page 파라미터에 $page 전달, query 파라미터에 _editingController! 에 입력한 text 값을 저장
        'target=title&pape=$page&query=${_editingController!.value.text}';
    //비동기 함수 내에서 await가 붙은 작업은 해당 작업이 끝날 때까지 다음작업으로 넘어가지 않고 기다림
    var response = await http.get(Uri.parse(url), // http.get() 함수를 통해 url 에 접속하는 코드
      headers: {"Authorization": "KakaoAK 748c81573b732010430f2a0a47e14a63"}); //KAKAO REST API 키 (본인 KEY 값으로 변경하기)
    setState(() { //다트 생명주기 부분 7단계 (데이터가 변경되었음을 알리는 함수. 변경된 데이터를 UI에 적용하기 위해 필요)
      var dataConvertedToJSON = jsonDecode(response.body); //jsonDecode?
      List result = dataConvertedToJSON['documents']; //dataConvertedToJSON 변수에서 ['documents'] 부분을 리스트 변수 result 에 저장
      data!.addAll(result); //data 변수에 result 리스트의 값들을 모두 저장 (이때 data 변수에는 null 값이 들어갈 수 없음)
    });
    return response.body;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  static const String _title = 'Widget example';

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: _title,
      home: WidgetApp(),
    );
  }
}
class WidgetApp extends StatefulWidget{
  @override
  _WidgetExampleState createState() => _WidgetExampleState();
}
class _WidgetExampleState extends State<WidgetApp>{
  List _buttonList = ['더하기', '빼기', '곱하기', '나누기'];
  List<DropdownMenuItem<String>> _dropDownMenuItems = new List.empty(growable: true); // 가변 List(growable) 고정은 Fixed-length
  String? _buttonText; // ? : 값이 null일 수 있음
  @override
  void initState(){ // 아이템 목록을 펼침 버튼에 넣을 메뉴 아이템으로 만들기
    super.initState();
    for(var item in _buttonList){
      _dropDownMenuItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    _buttonText = _dropDownMenuItems[0].value; // 기본 값은 더하기
  }
  String sum = '';
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Widdget Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
             Padding( // 결과 창
               padding: EdgeInsets.all(15), // 위젯 사이의 간격 벌리기
               child: Text('결과 : $sum',
               style: TextStyle(fontSize:20)),
             ),
              Padding( // 첫번째 값
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(keyboardType: TextInputType.number, controller: value1,),
              ),
              Padding( // 두번째 값
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(keyboardType: TextInputType.number, controller: value2,),
              ),
              Padding( // 계산 버튼
                padding: EdgeInsets.all(15),
                child: ElevatedButton( // 버튼 몸체
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add), // 아이콘
                      Text(_buttonText!) // ! : 값이 null이 아님
                    ],
                  ),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed:(){ // 누르면 계산
                    setState((){
                      var value1Int = double.parse(value1.value.text);
                      var value2Int = double.parse(value2.value.text);
                      var result;
                      if(_buttonText=='더하기'){
                        result = value1Int + value2Int;
                      }
                      else if(_buttonText =='빼기'){
                        result = value1Int - value2Int;
                      }
                      else if(_buttonText=='곱하기'){
                        result = value1Int * value2Int;
                      }
                      else{
                        result = value1Int / value2Int;
                      }
                      sum = '$result';
                    });
                  }
                ),
              ),
              Padding( // 아이템 고르기
                padding: EdgeInsets.all(15),
                child: DropdownButton(items:_dropDownMenuItems,onChanged:(String? value){ // 버튼에 아이템 가져오고 value 값 반환
                  setState((){
                    _buttonText = value; // 다른 아이템 고르면 바꾸기
                  });
                }, value: _buttonText,), // value 값 최신화
              ),
            ],
          ),
        ),
      ),
    );
  }
}

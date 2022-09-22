//플러터의 UI와 관련된 거의 모든 클래스가 들어있는 패키지
//Ctrl + \ = 핫 리로드 (바뀐 코드가 적용됨)
import 'package:flutter/material.dart';

void main() {
  //runApp() binding.dart 클래스에 정의. 플러터 앱을 시작하는 역할
  runApp(const MyApp());
}

//Stateless는 내용을 갱신할 필요가 없는 위젯 (정적)
//Stateful은 내용을 갱신해야할 위젯 (동적)
//상태가 변경되지않는 위젯을 상속받았다고 생각
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //@override 애너테이션을 이용해서 build() 함수 재정의
  @override
  Widget build(BuildContext context) {
    //MaterialApp() 함수에는 그림을 그리는 도구에 속하는 title, theme 그리고 home 등이 정의되어 있음
    return MaterialApp(
      //title : 앱 이름
      title: 'Flutter Demo',
      //theme : 앱의 테마를 무슨 색상으로 할지
      theme: ThemeData(
        //어떤 색상으로 할지
        primarySwatch: Colors.blue,
        //어떤 플랫폼에서도 자연스럽게 보이도록 지원
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home : 앱을 실행할 때 첫 화면에 어떤 내용을 표시할지
      //textAlign: TextAlign.center : 텍스트 내용을 가운데 정렬
      home: Container(
        color: Colors.white,
        child: Center(
          child: Text(
              'Hello\nflutter',
              textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
        )
      )

      //<이전에 한 코드들 정리된 주석>
      /*home: Center(
        child: Text('Hello\nFlutter', textAlign: TextAlign.center),
      )
      */
      //home: Text('hello\nFlutter', textAlign: TextAlign.center), //기본 테마는 검은 배경
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

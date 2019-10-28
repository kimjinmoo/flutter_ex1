import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ex1/domain/Post.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrepIU Post 읽기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ex1'),
    );
  }
}

class MyHomePage extends StatefulWidget {


  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  Future<PostResponse> post;

  Future<PostResponse> fetchPost() async {
    print('call post');
    final response = await http.get('https://conf.grepiu.com/grepiu/post?currentPage=0&size=100');

    if(response.statusCode == 200) {
      print("OK!!");
      return PostResponse.fromJson(json.decode(response.body));
    } else {
      print("OOPS");
      throw Exception('failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    print('fetch Post call');
    post = fetchPost();
    print('fetch Post end');
    WidgetsBinding.instance.addObserver(this);

  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      post = fetchPost();
    }
    print("lifecycle : " + state.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget listRow(String title, String regId) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            )
                        )
                    ),
                    Text(
                      "작성자 : "+regId,
                      style: TextStyle(
                          color: Colors.grey[500]
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      );
    }


//    Column _buildButtonColumn(Color color, IconData icon, String label) {
//      return Column(
//        mainAxisSize: MainAxisSize.min,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Icon(icon, color: color),
//          Container(
//            margin: const EdgeInsets.only(
//                top: 8
//            ),
//            child: Text(
//              label,
//              style: TextStyle(
//                fontSize: 12,
//                fontWeight: FontWeight.w400,
//                color: color
//              )
//            )
//          )
//        ],
//      );
//    }

//    Color color = Theme.of(context).primaryColor;

//    Widget buttonSession = Container(
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          _buildButtonColumn(color, Icons.call, 'Call'),
//          _buildButtonColumn(color, Icons.near_me, 'Route'),
//          _buildButtonColumn(color, Icons.share, 'Share'),
//        ],
//      )
//    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        '샘플 테스트',
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('GrepIU'),
      ),
      body: Center(
        child: FutureBuilder<PostResponse>(
                future: post,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    var productInfo = snapshot.data;
                    return new ListView.builder(
                      itemCount: snapshot.data.list.length,
                      itemBuilder: (BuildContext, int index) {
                        return listRow(productInfo.list[index].subject, productInfo.list[index].regId);
                      },
                    );
                  } else if(snapshot.hasError) {
                    return Text('ERROR');
                  } else {
                    return Text("EMPTY");
                  }
                },
        ),
      )
    );

//    return Scaffold(
//      appBar: AppBar(
//
//        title: Text(widget.title),
//      ),
//      body: Center(
//
//        child: ListView(
//          children: <Widget>[
//            titleSection,
//            buttonSession,
//            textSection,
//            Center(
//              child: FutureBuilder<PostResponse>(
//                future: post,
//                builder: (context, snapshot) {
//                  if(snapshot.hasData) {
//                    return Text(snapshot.data.list.toString());
//                  } else if(snapshot.hasError) {
//                    return Text('ERROR');
//                  } else {
//                    return Text("EMPTY");
//                  }
//                },
//              ),
//            )
//          ],
//        )
//      ),
//    );
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:borg_flutter/page/error_page.dart';
import 'package:borg_flutter/page/page_popup_menu.dart';
import 'package:borg_flutter/page/page_button.dart';
import 'package:borg_flutter/page/page_dropdown_button.dart';
import 'package:borg_flutter/page/page_expansion_panel.dart';
import 'package:borg_flutter/page/page_webview.dart';

void main() async{
  var isInDebugMode = false;

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorPage(details);
  };

  //全局的异常捕获
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    _handleError(error, stackTrace);
  });
}

void  _handleError(error, stackTrace) async{
  print("--------------_handleError begin---------------");
  print(error);
  print(stackTrace);
  print("--------------_handleError end-----------");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: routers,
    );
  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState()=>_MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  @override
  Widget build(BuildContext context) {
    var routerLists = routers.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new ListView.builder(
          itemCount: routers.length,
          itemBuilder: (context,index){
            //print("---------------------$index-------------------");
            return new InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(routerLists[index]);
              },
              child: new Card(
                child: new Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  child: new Text(routerName[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


var routerName = [
  "Popup Menu Button",
  "Buttons",
  "Dropdown Button",
  "Expansion Panel",
  FlutterWebviewPluginPage.name,
];

Map<String,WidgetBuilder> routers = {
  "widget/popup_menu_button": (context) {
    return PopupMenuPage();
  },
  "widget/buttons":(context){
    return ButtonsPage();
  },
  "widget/dropdown_button":(context){
    return DropdownButtonPage();
  },
  ExpansionPanelsDemo.routeName:(context){
    return ExpansionPanelsDemo();
  },
  FlutterWebviewPluginPage.routeName:(context){
    return FlutterWebviewPluginPage();
  },
};




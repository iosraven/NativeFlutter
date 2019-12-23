import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PushApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

     return MaterialApp(
       title: "Push",
       theme: ThemeData(
         primaryColor: Color(0xff72ca72),
       ),
       home: PushAppPage(),
     );
  }
}

class PushAppPage extends StatefulWidget {
   @override
   PushAppState createState() => new PushAppState();
}

const platform = const MethodChannel('qd.flutter.io/qd_PushApp'); 

class PushAppState extends State<PushAppPage> {


  // native 调用原生监听
  Future<dynamic> handleCall(MethodCall methodCall) {
    print(methodCall.toString());
    String backResult = "goBackSuccess";
    if(methodCall.method == "goBack"){
      if(Navigator.of(this.context).canPop()){
        Navigator.of(this.context).pop();
      }else{
        backResult = "goBackError";
      }
    }
    return Future.value(backResult);
  }

   void pushNativePage() {
     platform.invokeMapMethod('pushNativePage',{'key1':'value1'});
   }

  @override
  Widget build(BuildContext context) {
    
   platform.setMethodCallHandler(handleCall);
   
    return Scaffold(
      appBar: new AppBar(
        title: Text('Push'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('第一个页面内容'),
            new RaisedButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                   builder: (context) => PushSecondPage(),
                  ),
                );
              },
              child: Text('进入Flutter下一个页面'),
            ),
            new RaisedButton(
              onPressed: (){
                SystemNavigator.pop();
              },
              child: Text('关闭Flutter页面'),
            ),
            new RaisedButton(
              onPressed: (){
                pushNativePage();
              },
              child: Text('进入原生页面'),
            )
          ],
        ),),
    );
  } 
}


//  flutter第二个页面
class PushSecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
         appBar: new AppBar(
       title: Text('flutter第二个页面'),
     ),
    body: new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text('Flutter 第二个页面'),
          new  RaisedButton(
            onPressed: (){
              SystemNavigator.pop();
            },
            child: Text('关闭所有Flutter 页面'),
          ),
          new RaisedButton(
            onPressed: (){
              platform.invokeMethod('pushNativePage',{'Key1':'value1'});
            },
            child: Text('进入原生页面'),
          ),
        ],
      ),
    ),

    );
  }
  
}
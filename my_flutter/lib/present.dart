import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PresentAPP extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
     title: 'Present',
     debugShowCheckedModeBanner: false,
     debugShowMaterialGrid: false,
     theme: ThemeData(
       primarySwatch: Colors.blue,
     ),
     home: PresentAPPPage(title: 'flutter页面'),
    );
  }
}




class PresentAPPPage extends StatefulWidget{

    PresentAPPPage({Key key, this.title}): super(key: key);

    final String title;


    @override
   PresentAPPState createState() => PresentAPPState();
}



class PresentAPPState extends State<PresentAPPPage>{

  static const platform = const MethodChannel('qd.flutter.io/qd_PresentApp');
  
  String nativeBackString = "Not return"; 

  Future<void> invokeNativeGetResult() async{
     String backString;
     try {
       // 调用原生方法并且等待原生返回结果数据
      var result = await platform.invokeMethod(
           'getNativeResult',{"key1":"value1","key2":"value2"}
      );

//  Map<String, dynamic> map = {"code": "200", "data":[1,2,3]};
//     await methodChannel.invokeMethod('iOSFlutter1', map);

      backString = "原生传过来的数据是： $result";
     }on PlatformException catch (e){
       backString = "Failed to get native return:${e.message}";
     }
    print(backString);
     setState(() {
       nativeBackString = backString;
     });
  }



   Future<void> _communicateFunction(flutterPara) async {
    try {
      //原生方法名为callNativeMethond,flutterPara为flutter调用原生方法传入的参数，await等待方法执行
      await platform.invokeMethod('callNativeMethond', flutterPara);

    } on PlatformException catch (e) {//抛出异常
      //flutter: PlatformException(001, 进入异常处理, 进入flutter的trycatch方法的catch方法)
      print(e);
    }
  }


void dismiss() {
    // 直接调原生
    print('直接调原生 dismiss');
    platform.invokeMethod('dismiss');
}

void showAlertView() {
  // 直接调原生
    platform.invokeMethod('showAlertView');
}

void gotoNativeSecondPage() {
   // 直接调原生
   print('直接调原生 gotoNativeSecondPage');
   platform.invokeMethod('gotoNativeSecondPage');
}


   String mediaCall(BuildContext context){
    //  var media = MediaQuery.of(context);
    //  print(media.toString());
    //  print("设备像素密度：" + media.devicePixelRatio.toString());
    //  print(media.orientation);
    //  print("屏幕：" + media.size.toString());
    //  print('状态栏高度：' + media.padding.top.toString());
    //  return media.padding.toString();

        return "Flutter mediaCall方法调用";
   }

    Future<dynamic> _handler(MethodCall methodCall) {
     String backNative = "failure";
     if(methodCall.method == "flutterMedia"){
         print("flutterMedia传值过来的参数" + methodCall.arguments.toString());
       backNative = mediaCall(this.context);
     }else
     {
       print("调用了未知名字方法");
     }
     return Future.value(backNative);
    }
   
   
    void initState(){
        super.initState();
    }

  @override
  Widget build(BuildContext context) {

    // flutter 注册原生监听方法
   platform.setMethodCallHandler(_handler);
  //  platform.setMethodCallHandler(_handler2);
    return Scaffold(

     appBar: AppBar(
       title: Text(widget.title),
       leading: IconButton(
         icon: Icon(Icons.close),
         onPressed: (){
            dismiss();
         },
       ),
       ),
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Text(nativeBackString),

            RaisedButton(
              onPressed: gotoNativeSecondPage,
              color:Colors.blue[200],
              padding: EdgeInsets.fromLTRB(40, 15, 50, 20),
              textColor: Colors.white,
              textTheme:ButtonTextTheme.accent, 
              splashColor: Colors.red[50],
              elevation: 20,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: StadiumBorder(),
              onHighlightChanged: (boo){},
              child: Text('进入原生的第二个视图'),
          ),
            RaisedButton(
              onPressed: invokeNativeGetResult,
              color:Colors.blue[300],
              padding: EdgeInsets.fromLTRB(50, 15, 80, 20),
              textColor: Colors.white,
              textTheme:ButtonTextTheme.accent, 
              splashColor: Colors.red[50],
              elevation: 20,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: StadiumBorder(),
              onHighlightChanged: (boo){},
              child: Text('原生传值回调'),
            ),
             RaisedButton(
              onPressed: showAlertView,
              color:Colors.blueGrey[200],
              textColor: Colors.white,
              textTheme:ButtonTextTheme.accent, 
              elevation: 20,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: StadiumBorder(),
              onHighlightChanged: (boo){},
              child: Text('flutter调用原生方法 showAlertView'),
            ),
             RaisedButton(
              onPressed: (){_communicateFunction('麻烦新增用户：快乐的小鸟');},
              color:Colors.blueGrey[300],
              textColor: Colors.white,
              textTheme:ButtonTextTheme.accent, 
              elevation: 20,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: StadiumBorder(),
              onHighlightChanged: (boo){},
              child: Text('flutter调用原生方法+传值'),
            )
           ],
         ),
       )
    );
  }
}




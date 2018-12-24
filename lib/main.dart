import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'pages/home_page.dart';

Future<Null> main() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
   @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       title: 'PhotoKredy',

       theme: ThemeData(
          primarySwatch: Colors.blue,
       ),
       
       debugShowCheckedModeBanner: false,
       home: const HomePage(),
     );
  }
}

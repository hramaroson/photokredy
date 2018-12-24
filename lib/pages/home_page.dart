import 'package:flutter/material.dart';
import 'about_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: new Drawer(
          child: new ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              new DrawerHeader(
                child: new Text("PhotoKredy" , style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
                  decoration: new BoxDecoration(
                      color: Colors.blue
                  ),
               ),
              new ListTile(
                leading: const Icon(Icons.info_outline),
                title: new Text("About", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                    new MaterialPageRoute(builder: (context) => new AboutPage()));
                },
              ),
              new ListTile(
                leading: const Icon(Icons.settings),
                title: new Text("Settings", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => new SettingsPage()));
                },
              ),
            ],
          ),
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'about_page.dart';

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
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("PhotoKredy"),
               decoration: new BoxDecoration(
                  color: Colors.blue
               ),
            ),
            new ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About"),
              onTap: () {
                Navigator.push(context, 
                  new MaterialPageRoute(builder: (context) => new AboutPage()));
              },
            )

          ],
        ),
      )
    );
  }
}
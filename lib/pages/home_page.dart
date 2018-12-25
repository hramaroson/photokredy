// Copyright (C) 2018  Herizo Ramaroson
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
                leading: const Icon(Icons.info_outline , color: Colors.blue,),
                title: new Text("About", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                    new MaterialPageRoute(builder: (context) => new AboutPage()));
                },
              ),
              new ListTile(
                leading: const Icon(Icons.settings , color: Colors.blue,),
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
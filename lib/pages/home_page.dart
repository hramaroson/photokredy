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
import 'package:flutter_cameraview/flutter_cameraview.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraViewController _cameraViewController;
  Icon _flashButtonIcon = Icon(Icons.flash_off);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("PhotoKredy" , style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
                  decoration: new BoxDecoration(
                      color: Colors.blue
                  ),
               ),
              ListTile(
                leading: const Icon(Icons.info_outline , color: Colors.blue,),
                title: Text("About", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                    new MaterialPageRoute(builder: (context) => new AboutPage()));
                },
              ),
              ListTile(
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
        body: Stack(
          children: <Widget>[
            Container(
                color: Colors.black,
            ),
            Container(
              child: CameraView(
                onCreated: _onCameraViewCreated,
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      icon: _flashButtonIcon,
                      onPressed: _onFlashButtonPressed,
                    )
                  ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              width: 40.0,
              height: 40.0,
              right: 40.0,
              child: new IconButton(
                color: Colors.white,
                icon: new Icon(Icons.settings),
                onPressed: () {
                  new SettingsPage();
                },
              )
            )
          ],
        )
    );
  }

  void _onCameraViewCreated(CameraViewController controller){
    _cameraViewController = controller;
  }

  void _onFlashButtonPressed() async {
    Flash _flash = await _cameraViewController.getFlash();
    Icon _icon = Icon(Icons.flash_off);
    if(_flash == Flash.Off) {
        _flash = Flash.Torch;
        _icon = Icon(Icons.flash_on);
    }
    else {
      _flash = Flash.Off;
      _icon = Icon(Icons.flash_off);
    }

    await _cameraViewController.setFlash(_flash);

    setState(() {
        _flashButtonIcon = _icon;
    });
  }
}

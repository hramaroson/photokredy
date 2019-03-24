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
import 'package:photokredy_core/photokredy_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'about_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver { 
  CameraViewController _cameraViewController;
  Icon _flashButtonIcon = Icon(Icons.flash_off);
  bool _hasCameraAccess = false;
<<<<<<< HEAD

  void _init(){
    PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((status){
         setState(() => _hasCameraAccess = (status == PermissionStatus.granted));
    });

    if(_cameraViewController != null && _hasCameraAccess) { 
          _cameraViewController.open(); //ensure Camera is opened
          setState(() => _hasCameraAccess = true);
       }
  }
=======
>>>>>>> refs/remotes/origin/master

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.resumed){
        //Handle permissions
       _init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                  _showSettingsPage();
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
                      onPressed: _hasCameraAccess? _onFlashButtonPressed : null,
                    )
                  ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              width: 40.0,
              height: 40.0,
              right: 10.0,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.settings),
                onPressed: () => _showSettingsPage()
              )
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Offstage(
                offstage: _hasCameraAccess,
                child: _cameraPermissionRequestDialog()
              )
              
            )
          ],
        )
    );
  }

  void _onCameraViewCreated(CameraViewController controller){
    _cameraViewController = controller;
  }

  Widget _cameraPermissionRequestDialog(){ 
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "PhotoKredy needs a Camera" , 
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white)),
          RaisedButton(
            child: Text(
              "Allow" , 
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              PermissionHandler().requestPermissions([PermissionGroup.camera]).then((permissions){
                 if(permissions[PermissionGroup.camera] == PermissionStatus.granted){
                    setState(() => _hasCameraAccess = true);
                 }
              });
            }
          )
        ],
      ),
    );
  }

  void _onFlashButtonPressed() async {
    Flash _flash = await _cameraViewController.getFlash();
    if(_flash == null)
      return;

    Icon _icon = Icon(Icons.flash_off);
    if(_flash == Flash.Off) {
      _flash = Flash.Torch;
      _icon = Icon(Icons.flash_on);
    }
    else {
      _flash = Flash.Off;
      _icon = Icon(Icons.flash_off);
    }
    
    if(await _cameraViewController.setFlash(_flash)) {
      setState(() => _flashButtonIcon = _icon);
    }
  }

  void _showSettingsPage(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new SettingsPage()));
  }
}

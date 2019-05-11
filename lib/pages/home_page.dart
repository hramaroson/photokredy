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
import 'package:photokredy/localizations.dart';
import 'package:photokredy/application.dart';
import 'widgets/camera_focus_widget.dart';
import 'widgets/main_ui_widget.dart'; 

import 'about_page.dart';
import 'settings_page.dart';


class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver { 
  CameraController _cameraController;
  Icon _flashButtonIcon = Icon(Icons.flash_off);
  bool _hasCameraAccess = false;
  bool _firstStart = true;
  
  void _init(){
    PermissionHandler().checkPermissionStatus(PermissionGroup.camera).then((status){
         setState(() => _hasCameraAccess = (status == PermissionStatus.granted));
         _firstStart = false;
    });

  }

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
    return Scaffold(
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  AppLocalizations.of(context).appTitle() , 
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
                  decoration: BoxDecoration(
                      color: Colors.blue
                  ),
               ),
              ListTile(
                leading: const Icon(Icons.settings , color: Colors.blue,),
                title: Text(
                  AppLocalizations.of(context).settingsPageTitle(),  
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.pop(context);
                  _showSettingsPage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline , color: Colors.blue,),
                title: Text(
                  AppLocalizations.of(context).aboutPageTitle(), 
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
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
            Offstage(
              offstage: _hasCameraAccess || _firstStart,
              child: Center (
                child: _cameraPermissionRequestDialog()
              )
            ),
            Offstage(
              offstage: !_hasCameraAccess,
              child: Container( 
                child: CameraFocusWidget(),
              )
            ),
            Offstage(
              offstage: !_hasCameraAccess,
              child: MainUiWidget()
            )
          ],
        )
    );
  }

  void _onCameraViewCreated(CameraController controller){
    _cameraController = controller;
    _cameraController.addCameraEventListener(CameraEventListener(
      onOpened: _onCameraOpened, 
      onClosed: _onCameraClosed,
      onFocusStarted: _onCameraFocusStarted
    ));
  }

  Widget _cameraPermissionRequestDialog(){ 
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).homePageCameraRequestDialogContentText() , 
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white)),
          RaisedButton( 
            child: Text(
              AppLocalizations.of(context).homePageCameraRequestDialogButtonLabel(), 
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

  void _onCameraOpened() {
    setState(() => application.cameraStatus = CameraStatus.Opening);
  }

  void _onCameraClosed(){
    setState(() => application.cameraStatus = CameraStatus.None);
  }

  void _onCameraFocusStarted(){
    setState(() => application.cameraStatus = CameraStatus.Focusing);
  }

  void _onFlashButtonPressed() async {
    Flash _flash = await _cameraController.getFlash();
    
    Icon _icon = Icon(Icons.flash_off);
    if(_flash == Flash.Off) {
      _flash = Flash.Torch;
      _icon = Icon(Icons.flash_on);
    }
    else {
      _flash = Flash.Off;
      _icon = Icon(Icons.flash_off);
    }
    
    _cameraController.setFlash(_flash);
    setState(() => _flashButtonIcon = _icon);
  }

  void _showSettingsPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }
}

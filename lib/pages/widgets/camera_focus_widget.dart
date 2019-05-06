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
import 'package:audioplayers/audio_cache.dart';
import 'package:photokredy/application.dart';

const String cameraFocusSound = "camera_focus_beep.mp3";

class CameraFocusWidget extends StatefulWidget {
  const CameraFocusWidget(); 

  _CameraFocusWidgetState createState() => _CameraFocusWidgetState();
}

class _CameraFocusWidgetState extends State<CameraFocusWidget> 
  with SingleTickerProviderStateMixin {
  CameraStatus _status = CameraStatus.None;

  AnimationController _controller;
  Animation<double> _animation; 

  AudioCache _player = AudioCache();
  
  @override
  void initState(){
    super.initState();

    //prebuild AnimationController
    _controller = AnimationController(duration: const Duration(milliseconds:  700), vsync: this);
  }

  void _init(){
    //skip init if opening animation is already started
    bool animated = (application.cameraStatus == CameraStatus.Opening 
      && _status != CameraStatus.Opening 
      && _status != CameraStatus.Idle) 

    //skip init if focusing animation is already started (or opening animation while focusing)
    || (application.cameraStatus == CameraStatus.Focusing 
      && _status != CameraStatus.Focusing 
      && _status != CameraStatus.Opening);


    if(animated){ 
       _initAnimation();
    } 
    else if(application.cameraStatus == CameraStatus.None){
       _status = application.cameraStatus;
    }
  }

  void _initAnimation(){
     _controller.reset();
    if(application.cameraStatus == CameraStatus.Focusing){
        //modify animation duration for focus animation
        _controller.duration = Duration(milliseconds: 400); 

        if(application.soundEnabled) {
            _player.play(cameraFocusSound);
        }
    }
    else {
        _controller.duration = Duration(milliseconds: 700); 
    }
    _animation = Tween<double> (
      begin: 0.0,
      end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.decelerate
          )
      )
      ..addStatusListener(_handleAnimationStatus);
        
      _status = application.cameraStatus;
      _controller.forward();
  }

  void _handleAnimationStatus(AnimationStatus status){
    if (status == AnimationStatus.completed) {
      if(_status == CameraStatus.Focusing) {
         _controller.reverse(); //bring the focus marker to its idle  position
      } else {
         //get back to idle state
          application.cameraStatus = CameraStatus.Idle; 
          _status = CameraStatus.Idle;
      }
          
    }
    else if(status == AnimationStatus.dismissed) {
      if(_status == CameraStatus.Focusing){
        //get back to idle state
        application.cameraStatus = CameraStatus.Idle; 
        _status = CameraStatus.Idle;
      }
    }
  }

  @override
  Widget build(BuildContext context){
    _init();

    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: _controller 
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child){
    Size size = MediaQuery.of(context).size;
    return CustomPaint(
      child: Container(
        width: size.width,
        height: size.height
      ),
      foregroundPainter: CameraFocusWidgetPainter(_animation, _status),
    );
  }

  @override
  void dispose(){
    _controller?.dispose();
    super.dispose();
  }
}

class CameraFocusWidgetPainter extends CustomPainter{
  Animation<double> _animation;
  final CameraStatus _status;

  CameraFocusWidgetPainter(this._animation, this._status);

  @override
  void paint(Canvas canvas, Size size){
    switch(_status) {
       case CameraStatus.Idle:
          _drawOnIdle(canvas, size);
          break;
       case CameraStatus.Opening:
          _drawOpeningAnimation(canvas, size);
          break;
       case CameraStatus.Focusing:
          _drawFocusingAnimation(canvas, size);
          break;
       default: //nothing is drawn on screen when no focus state is set
          break;
    }
  }

  Paint _pen(){
    Paint pen = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;
      return pen;
  }
  
  void _drawOnIdle(Canvas canvas, Size size){
    Paint pen = _pen();

    double centerX = size.width/2.0;
    double centerY = size.height/3.0; 

    double roiRadiusWidth = size.width / 2.0 - 10.0;
    double roiRadiusHeight = roiRadiusWidth / 2.2;

    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
      centerX + roiRadiusWidth, centerY + roiRadiusHeight);

    _drawFocusMark(canvas,paintRect,pen);

  }

  void _drawOpeningAnimation(Canvas canvas, Size size){
    Paint pen = _pen();

    double centerX = size.width/2.0;
    double centerY = size.height/3.0; 

    double roiRadiusWidth = size.width / 2.0 - 10.0;
    double roiRadiusHeight = roiRadiusWidth / 2.2;

    double delta = _animation.value;
    roiRadiusWidth *= delta;
    roiRadiusHeight *= delta;
    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
      centerX + roiRadiusWidth, centerY + roiRadiusHeight);
    
    if(!_animation.isCompleted)
       pen.color = Colors.lightGreen;

    _drawFocusMark(canvas, paintRect, pen);
  }

  void _drawFocusMark(Canvas canvas, Rect rect, Paint pen){
    double length = 0.07 * rect.width;

    //horizontal lines
    canvas.drawLine(Offset(rect.left, rect.top),
                    Offset(rect.left + length, rect.top), pen);
    canvas.drawLine(Offset(rect.right, rect.top),
                    Offset(rect.right - length, rect.top), pen);
    canvas.drawLine(Offset(rect.left, rect.bottom),
                    Offset(rect.left + length, rect.bottom),pen);
    canvas.drawLine(Offset(rect.right, rect.bottom),
                    Offset(rect.right - length, rect.bottom), pen);

    //vertical lines
    canvas.drawLine(Offset(rect.left, rect.top),
                    Offset(rect.left, rect.top + length), pen);
    canvas.drawLine(Offset(rect.right, rect.top),
                    Offset(rect.right, rect.top + length), pen);
    canvas.drawLine(Offset(rect.left, rect.bottom),
                    Offset(rect.left, rect.bottom - length), pen);
    canvas.drawLine(Offset(rect.right, rect.bottom),
                    Offset(rect.right, rect.bottom - length), pen);
  }

  void _drawFocusingAnimation(Canvas canvas, Size size){
    Paint pen = _pen();

    double centerX = size.width/2.0;
    double centerY = size.height/3.0; 

    double roiRadiusWidth = size.width / 2.0 - 10.0;
    double roiRadiusHeight = roiRadiusWidth / 2.2;

    double delta = 1 + 0.07 * _animation.value;
    roiRadiusWidth *= delta;
    roiRadiusHeight *= delta;
    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
      centerX + roiRadiusWidth, centerY + roiRadiusHeight);
    
    if(!_animation.isCompleted)
       pen.color = Colors.lightGreen;

    _drawFocusMark(canvas, paintRect, pen);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}
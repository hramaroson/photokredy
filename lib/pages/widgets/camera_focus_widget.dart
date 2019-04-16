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

enum CameraFocusWidgetStatus {
    None,
    Idle,
    Opening,
    Focusing,
}

class CameraFocusWidget extends StatefulWidget {
  static CameraFocusWidgetStatus status = CameraFocusWidgetStatus.Opening;
  

  CameraFocusWidget(); 

  _CameraFocusWidgetState createState() => _CameraFocusWidgetState();
}

class _CameraFocusWidgetState extends State<CameraFocusWidget> 
  with SingleTickerProviderStateMixin {
  CameraFocusWidgetStatus _status = CameraFocusWidgetStatus.None;

  AnimationController _controller;
  Animation<double> _animation; 
  
  @override
  void initState(){
    super.initState();

    //prebuild AnimationController
    _controller = AnimationController(duration: const Duration(seconds:  1), vsync: this);
  }

  void _init(){
    if(CameraFocusWidget.status == CameraFocusWidgetStatus.Opening 
        && _status != CameraFocusWidgetStatus.Opening ){
           _controller.reset();

          _animation = Tween<double> (
          begin: 0.0,
          end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.decelerate
              )
          )
        ..addStatusListener(_handleAnimationStatus);
        
        _status = CameraFocusWidgetStatus.Opening;
        _controller.forward();
    }
  }

  void _handleAnimationStatus(AnimationStatus status){
    if (status == AnimationStatus.completed){

     //get back to idle state
     CameraFocusWidget.status = CameraFocusWidgetStatus.Idle; 
     _status = CameraFocusWidgetStatus.Idle;
    }
  }

  @override
  Widget build(BuildContext context) {
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

class CameraFocusWidgetPainter extends CustomPainter {
  Animation<double> _animation;
  final CameraFocusWidgetStatus _status;

  CameraFocusWidgetPainter(this._animation, this._status);

  @override
  void paint(Canvas canvas, Size size) {
    switch(_status) {
       case CameraFocusWidgetStatus.Idle:
          _drawOnIdle(canvas, size);
          break;
       case CameraFocusWidgetStatus.Opening:
          _drawOpeningAnimation(canvas, size);
          break;
       default: //nothing is drawn on screen when no focus state is set
          break;
    }
  }
  
  void _drawOnIdle(Canvas canvas, Size size){
    Paint pen = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;

    double centerX = size.width/2.0;
    double centerY = size.height/3.0; 

    double roiRadiusWidth = size.width / 2.0 - 10.0;
    double roiRadiusHeight = roiRadiusWidth / 2.2;

    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
      centerX + roiRadiusWidth, centerY + roiRadiusHeight);

    _drawFocusMark(canvas,paintRect,pen);

  }

  void _drawOpeningAnimation(Canvas canvas, Size size){
    Paint pen = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;

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

    _drawFocusMark(canvas,paintRect,pen);
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
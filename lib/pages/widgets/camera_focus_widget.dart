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

class CameraFocusWidget extends StatefulWidget {
  const CameraFocusWidget();
   _CameraFocusWidgetState createState() => _CameraFocusWidgetState();
}

class _CameraFocusWidgetState extends State<CameraFocusWidget> 
  with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _controller;
  Animation<double> _animation; 

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _init();
  }

  void _init(){
     if( _controller == null) {
       _controller = AnimationController(duration: const Duration(milliseconds:  500), vsync: this);
     }
    _controller.reset();
    _animation = Tween<double>(
        begin: 0.0,
        end: 1.0).animate(
          CurvedAnimation(
            parent:_controller, 
            curve: Curves.easeIn
          )
        )
    ..addStatusListener(_handleAnimationStatus);
     _controller.forward();
  }

  void _handleAnimationStatus(AnimationStatus status){
    if (status == AnimationStatus.completed) {
        _animation.removeStatusListener(_handleAnimationStatus);
        _controller.reset();

        _animation = Tween<double>(
          begin: 1.0,
          end: 0.0).animate(
            CurvedAnimation(
              parent:_controller, 
              curve: Curves.easeIn
            )
        );
        _controller.forward();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
       _init();
    }
  }

  @override
  Widget build(BuildContext context) {
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
      foregroundPainter: CameraFocusWidgetPainter(_animation),
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
  CameraFocusWidgetPainter(this._animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0;

    double centerX = size.width/2.0;
    double centerY = size.height/3.0; 

    double roiRadiusWidth = size.width / 2.0 - 10.0;
    double roiRadiusHeight = roiRadiusWidth / 2.2;

    double delta = 1 +  0.07 * _animation.value;
    roiRadiusWidth *= delta;
    roiRadiusHeight *= delta;
    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
      centerX + roiRadiusWidth, centerY + roiRadiusHeight);
    
    if(!_animation.isCompleted)
       line.color = Colors.lightGreen;

    double length = 0.07 * paintRect.width;

    //horizontal lines
    canvas.drawLine(Offset(paintRect.left, paintRect.top),
                    Offset(paintRect.left + length, paintRect.top), line);
    canvas.drawLine(Offset(paintRect.right, paintRect.top),
                    Offset(paintRect.right - length, paintRect.top), line);
    canvas.drawLine(Offset(paintRect.left, paintRect.bottom),
                    Offset(paintRect.left + length, paintRect.bottom),line);
    canvas.drawLine(Offset(paintRect.right, paintRect.bottom),
                    Offset(paintRect.right - length, paintRect.bottom), line);

    //vertical lines
    canvas.drawLine(Offset(paintRect.left, paintRect.top),
                    Offset(paintRect.left, paintRect.top + length), line);
    canvas.drawLine(Offset(paintRect.right, paintRect.top),
                    Offset(paintRect.right, paintRect.top + length), line);
    canvas.drawLine(Offset(paintRect.left, paintRect.bottom),
                    Offset(paintRect.left, paintRect.bottom - length), line);
    canvas.drawLine(Offset(paintRect.right, paintRect.bottom),
                    Offset(paintRect.right, paintRect.bottom - length), line);
   }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
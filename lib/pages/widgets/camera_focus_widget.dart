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
  with SingleTickerProviderStateMixin  {
  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState(){
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInBack)
      ..addStatusListener((status) {
        setState(() {});
      });
    _controller.forward(); //initial animation
  }
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height
      ),
      foregroundPainter: CameraFocusWidgetPainter(_animation),
    );
  }
  @override
  void dispose(){
    _controller.dispose();
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

    double delta = 0.05 * _animation.value;
    roiRadiusWidth += roiRadiusWidth * delta;
    roiRadiusHeight += roiRadiusHeight * delta;
    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
      centerX + roiRadiusWidth, centerY + roiRadiusHeight);
    
    if(!_animation.isCompleted)
       line.color = Colors.lightGreen;

    double length = 0.07 * paintRect.width;

    //horizontal lines
    canvas.drawLine(Offset (paintRect.left, paintRect.top),
                    Offset (paintRect.left + length, paintRect.top), line);
    canvas.drawLine(Offset (paintRect.right, paintRect.top),
                    Offset (paintRect.right - length, paintRect.top), line);
    canvas.drawLine(Offset (paintRect.left, paintRect.bottom),
                    Offset (paintRect.left + length, paintRect.bottom),line);
    canvas.drawLine(Offset (paintRect.right, paintRect.bottom),
                    Offset (paintRect.right - length, paintRect.bottom), line);

    //vertical lines
    canvas.drawLine(Offset (paintRect.left, paintRect.top),
                    Offset (paintRect.left, paintRect.top + length), line);
    canvas.drawLine(Offset (paintRect.right, paintRect.top),
                    Offset (paintRect.right, paintRect.top + length), line);
    canvas.drawLine(Offset (paintRect.left, paintRect.bottom),
                    Offset (paintRect.left, paintRect.bottom - length), line);
    canvas.drawLine(Offset (paintRect.right, paintRect.bottom),
                    Offset (paintRect.right, paintRect.bottom - length), line);
   }

   @override
   bool shouldRepaint(CustomPainter oldDelegate) {
     return true;
   }
}
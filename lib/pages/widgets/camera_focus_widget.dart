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

class CameraFocusWidget extends CustomPainter {
  bool _continuousFocusMoving = true;
  int _continuousFocusMovingMs = 0;

  @override
  void paint(Canvas canvas, Size size) {
    _doFocusAnimation(canvas,size, DateTime.now().microsecondsSinceEpoch);
  }
  void _doFocusAnimation(Canvas canvas, Size size, int timeMs){
    bool isAnimated = false;

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
    Rect paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight,
     centerX + roiRadiusWidth, centerY + roiRadiusHeight);

    if(_continuousFocusMoving){
      isAnimated = true;
      int dt = timeMs - _continuousFocusMovingMs;
      final int length = 1000;
      if( dt <=length) {
        double frac = dt.toDouble() / length.toDouble();
        double roiRadiusMaxWidth = roiRadiusWidth * 1.05;
        double roiRadiusMaxHeight = roiRadiusHeight * 1.05;
        double alpha = 0.0;
        if(frac < 0.5){
          alpha = frac * 2.0;
          roiRadiusWidth = (1.0 - alpha) * roiRadiusWidth + alpha * roiRadiusMaxWidth;
          roiRadiusHeight = (1.0 - alpha) * roiRadiusHeight + alpha * roiRadiusMaxHeight;
        }
        else {
          alpha = (frac - 0.5) * 2.0; 
          roiRadiusWidth = (1.0 - alpha) * roiRadiusMaxWidth + alpha + roiRadiusWidth;
          roiRadiusHeight = (1.0 - alpha) * roiRadiusMaxHeight + alpha * roiRadiusHeight;
        }
        paintRect = Rect.fromLTRB(centerX - roiRadiusWidth, centerY - roiRadiusHeight , 
        centerX + roiRadiusWidth, centerY + roiRadiusHeight);
      }
      else {
        isAnimated = false;
        clearContinuousFocusMove();
      }
    }
    if(isAnimated)
      line.color = Colors.yellowAccent;

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

  void clearContinuousFocusMove(){
    if(_continuousFocusMoving){
        _continuousFocusMoving = false;
        _continuousFocusMovingMs = 0;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
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
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
    double cx = size.width/2.0;
    double cy= size.height/3.0; 

    double roi_rw = size.width /2.0 - 10.0;
    double roi_rh = roi_rw / 2.2;
    Rect p_rect = Rect.fromLTRB(cx - roi_rw, cy - roi_rh, cx + roi_rw, cy + roi_rh);

    double length = 0.08 * p_rect.width;

    //horizontal lines
    canvas.drawLine(Offset (p_rect.left, p_rect.top),
                    Offset (p_rect.left + length, p_rect.top), line);
    canvas.drawLine(Offset (p_rect.right, p_rect.top),
                    Offset (p_rect.right - length, p_rect.top), line);
    canvas.drawLine(Offset (p_rect.left, p_rect.bottom),
                    Offset (p_rect.left + length, p_rect.bottom),line);
    canvas.drawLine(Offset (p_rect.right, p_rect.bottom),
                    Offset (p_rect.right - length, p_rect.bottom), line);

    //vertical lines
    canvas.drawLine(Offset (p_rect.left, p_rect.top),
                    Offset (p_rect.left, p_rect.top + length), line);
    canvas.drawLine(Offset (p_rect.right, p_rect.top),
                    Offset (p_rect.right, p_rect.top + length), line);
    canvas.drawLine(Offset (p_rect.left, p_rect.bottom),
                    Offset (p_rect.left, p_rect.bottom - length), line);
    canvas.drawLine(Offset (p_rect.right, p_rect.bottom),
                    Offset (p_rect.right, p_rect.bottom - length), line);

    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
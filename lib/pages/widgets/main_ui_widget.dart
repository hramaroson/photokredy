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

class MainUiWidget extends StatefulWidget {
  const MainUiWidget();

  _MainUiWidgetState createState() => _MainUiWidgetState();
}

class _MainUiWidgetState extends State<MainUiWidget> 
  with SingleTickerProviderStateMixin{
  AnimationController _controller;

  @override
  void initState(){
    super.initState();

     _controller = AnimationController(duration: const Duration(milliseconds:  700), vsync: this);
  }
  void _init(){

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
    return Container();
  }
}
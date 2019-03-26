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
import 'package:preferences/preferences.dart';

class SettingsPage extends StatelessWidget {
  Widget build(BuildContext context){
    return Scaffold (
      appBar: new AppBar(title: new Text("Settings")),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          "Language",
          "locale",
          desc: "Language used by the interface",
          defaultVal: "en",
          values: ["en", "fr","mg"],
          displayValues: ["English", "Français","Malagasy"]
        ),
        SwitchPreference(
          "Sound", 
          "sound",
          desc: "Enable/disable sound",
          defaultVal: false)
      ]),
    );
  }
}
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

import "dart:async";

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';
import 'application.dart';

Future<void> main() async { 
    await PrefService.init(prefix: 'pref_');
    runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  AppLocalizationsDelegate _newLocalizationsDelegate;

  @override
  void initState() {
    super.initState();
    
    String languageCode = PrefService.getString("language");
    _newLocalizationsDelegate = AppLocalizationsDelegate(
      newLocale: application.supportedLanguagesCodes.contains(
        languageCode)? Locale(languageCode) : null);

    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       title: 'PhotoKredy',

       supportedLocales: application.supportedLocales(),

       localizationsDelegates: [
         _newLocalizationsDelegate,
         GlobalMaterialLocalizations.delegate,
         GlobalWidgetsLocalizations.delegate,
       ],

       theme: ThemeData(
          primarySwatch: Colors.blue,
       ),
       
       debugShowCheckedModeBanner: false,
       home: const HomePage(),
     );
  }

   void onLocaleChange(Locale locale) {
    setState(() {
      _newLocalizationsDelegate = AppLocalizationsDelegate(newLocale: locale);
    });
  }
}

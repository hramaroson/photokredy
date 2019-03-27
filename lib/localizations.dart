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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';
import 'application.dart';

class  AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  app_title() => Intl.message("PhotoKredy", name: "app_title");
  settings() => Intl.message("Settings", name: "settings");
  settings_page_general() => Intl.message("General", name: "settings_page_general");
  settings_page_language() => Intl.message("Language", name: "settings_page_language");
  settings_page_language_desc() => Intl.message("Language used by the interface", 
    name: "settings_page_language_desc");
  settings_page_sound() => Intl.message("Sound", name: "settings_page_sound");
  settings_page_sound_desc() => Intl.message("Enable/disable sound", 
    name: "settings_page_sound_desc"); 
  about() => Intl.message("About", name: "about");
  homepage_camera_request_dialog_allow()=> Intl.message("Allow", 
    name: "homepage_camera_request_dialog_allow"); 
  homepage_camera_request_dialog_message() => Intl.message("PhotoKredy needs a Camera", 
    name: "homepage_camera_request_dialog_message"); 
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale newLocale;

  const AppLocalizationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return true;
  }

}

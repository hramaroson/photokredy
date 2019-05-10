# PhotoKredy
| | **Travis CI**|**Gitlab CI**|
|---  |---  |---  |
| [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE) | [![Build Status](https://travis-ci.org/hramaroson/photokredy.svg?branch=master)](https://travis-ci.org/hramaroson/photokredy) | [![pipeline status](https://gitlab.com/hramaroson/photokredy/badges/master/pipeline.svg)](https://gitlab.com/hramaroson/photokredy/pipelines) |

Mobile app providing prepaid phone card fast and easy scanning.

## Building the project
### Setup development environment
The following tools are required:
* [Android Studio](https://developer.android.com/studio/) with [Dart/Flutter plugin](https://flutter.dev/docs/get-started/editor) installed.
* [Flutter](https://flutter.dev/docs/get-started/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) with [Dart/Flutter plugin](https://dartcode.org/) installed (optional, for code editing).


### Download and build the project
* Clone the repository with the `git clone` command.

```
$ git clone --recurse-submodules https://github.com/hramaroson/photokredy.git
```

* Install dependencies in `pubspec.yaml` by running the following command in the project root directory (see [using packages documentation](https://flutter.io/using-packages/#adding-a-package-dependency-to-an-app) for details and how to do this in the editor).

```
$ flutter packages get
```
* Build the project:
    - On Android (armeabi-v7a):  `flutter build apk`
    - On Android (arm64-v8a): `flutter build apk --target=android-arm64`
    - On iOS: `flutter build ios`

* If you have a connected device or emulator you can run and deploy the app by running :

```
$ flutter run
```

## Licenses
<img src="https://gnu.org/graphics/gplv3-127x51.png" alt=""/>

Copyright (C) 2018 Herizo Ramaroson

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
[GNU General Public License](LICENSE) for more details.


### Third party
#### <img src="https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png" alt="Flutter" width="100" height="50"/> 

Flutter is Google’s mobile app SDK for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source. 

License is [here](https://github.com/flutter/flutter/blob/master/LICENSE). 

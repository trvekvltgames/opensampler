//==============================================================================
//    main.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

import 'padscreen.dart';
import 'settings.dart';

//==============================================================================

// Global preferences object.
SharedPreferences preferences;

// The directory for that we will be saving to.
Directory documentDirectory;

// Information about the app package.
PackageInfo packageInfo;

// Key used in preferences to store/retrieve path of the last used project.
const String lastFileKey = "lastProject";

// Key used in preferences to store/retrieve font size to use in pads.
const String fontSizeKey = "fontSize";

//==============================================================================

// Application entry point.
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await SharedPreferences.getInstance();
  documentDirectory = await getApplicationDocumentsDirectory();
  packageInfo = await PackageInfo.fromPlatform();

  var settings = await loadSettings();

  runApp(MaterialApp(
    title: 'Open Sampler',
    theme: ThemeData(
      primaryColor: Colors.blueGrey,
    ),
    darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
    ),
    home: PadScreen(settings),
  ));
}

//==============================================================================

Future<Settings> loadSettings() async {

  String last = preferences.getString(lastFileKey);

  if (last == null ||  last.isEmpty) {
    String path = documentDirectory.path;
    last = '$path/temp.json';
  }

  File settingsFile = File(last);

  bool exists = await settingsFile.exists();

  if (exists) {
    try {
      // Read the file.
      String json = await settingsFile.readAsString();
      return new Settings.fromJson(settingsFile, json);
    } catch (e) {
      print(e.toString());
    }
  }

  return defaultSettings;
}

//==============================================================================

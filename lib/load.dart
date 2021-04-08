//------------------------------------------------------------------------------
//    padscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

//------------------------------------------------------------------------------

class LoadScreen extends StatelessWidget {

  LoadScreen(this.fileList);

  final List<File> fileList;

  void _onChoose(BuildContext context, String name, File file) async
  {
    var ok = await confirm(context, title: Text('Do you want to open project ' + name + '?'));

    if (ok)
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("last", file.absolute.path);

      Navigator.pop(context, file);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    List<Widget> widgets = [];

    for (File f in fileList)
    {
      String base = basename(f.path);
      String name = base.substring(0, base.length - ".json".length);
      widgets.add(ListTile(title: Text(name), onTap: () {_onChoose(context, name, f); }));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Open Project"),
        ),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: widgets),
            )));
    }
}
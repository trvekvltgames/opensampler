//==============================================================================
//    padscreen.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'main.dart';

//==============================================================================

class LoadScreen extends StatefulWidget {

  //----------------------------------------------------------------------------

  final List<File> _fileList;

  //----------------------------------------------------------------------------

  LoadScreen(this._fileList);

  //----------------------------------------------------------------------------

  @override
  _LoadScreenState createState() => _LoadScreenState(_fileList);

  //----------------------------------------------------------------------------
}

//==============================================================================

class _LoadScreenState extends State<LoadScreen> {

  //----------------------------------------------------------------------------

  final List<File> _fileList;

  //----------------------------------------------------------------------------

  _LoadScreenState(this._fileList);

  //----------------------------------------------------------------------------

  void _onChoose(BuildContext context, String name, File file) async
  {
    var ok = await confirm(context, title: Text('Do you want to open project ' + name + '?'));

    if (ok) {
      preferences.setString(lastFileKey, file.absolute.path);
      Navigator.pop(context, file);
    }
  }

  //----------------------------------------------------------------------------

  void _onDelete(BuildContext context, String name, File file) async
  {
    var ok = await confirm(context, title: Text('Do you want to delete project ' + name + '?'));

    if (ok) {
      file.delete();
      _fileList.remove(file);
    }

    setState(() {});
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context)
  {
    List<Widget> widgets = [];

    TextStyle style = TextStyle(fontSize: 22);

    for (File f in _fileList)
    {
      String base = basename(f.path);
      String name = base.substring(0, base.length - ".json".length);

      widgets.add(Row(children: <Widget> [
        InkWell(
            child: Text(name, style: style),
            onTap: () {_onChoose(context, name, f); }),
        Spacer(),
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () { _onDelete(context, name, f); })
      ]));

      widgets.add(Divider());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Open Project"),
        ),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Center(
              child: ListView(children: widgets),
            )));
    }

  //----------------------------------------------------------------------------
}

//==============================================================================
//==============================================================================
//    padsettings.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//==============================================================================

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:opensampler/settings.dart';
import 'package:path/path.dart';

//==============================================================================

class PadSettingsScreen extends StatefulWidget {

  //----------------------------------------------------------------------------

  final int _padX;
  final int _padY;
  final PadSettings _settings;

  //----------------------------------------------------------------------------

  PadSettingsScreen(this._padX, this._padY, this._settings);

  //----------------------------------------------------------------------------

  @override
  _PadSettingsScreenState createState() => _PadSettingsScreenState(_padX, _padY, _settings);

  //----------------------------------------------------------------------------
}

//==============================================================================

class _PadSettingsScreenState extends State<PadSettingsScreen> {

  //----------------------------------------------------------------------------

  final int _padX;
  final int _padY;
  final PadSettings _settings;

  //----------------------------------------------------------------------------

  _PadSettingsScreenState(this._padX, this._padY, this._settings);

  //----------------------------------------------------------------------------

  void _onSelectSample() async
  {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null)
      _settings.sample = result.files.single.path;

    bool isNumber = double.parse(_settings.caption) != null;

    if (_settings.caption.isEmpty || isNumber)
    {
      String str = basename(_settings.sample);
      str = str.substring(0, str.lastIndexOf('.'));

      _settings.caption = str;
    }

    _settings.save();

    setState(() {});
  }

  //----------------------------------------------------------------------------

  void _onChangeCaption(BuildContext context) async
  {
    TextEditingController controller = TextEditingController();
    controller.text = _settings.caption;

    var ok = await confirm(context, title: Text('Input pad name'), content: TextField(controller: controller));

    if (ok)
      _settings.caption = controller.text;

    _settings.save();

    setState(() {});
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    String sampleName = _settings.sample.isNotEmpty ? basename(_settings.sample) : "";
    String caption = _settings.caption.isEmpty ? (sampleName.isNotEmpty ? sampleName.substring(0, sampleName.lastIndexOf('.')) : "") : _settings.caption;

    int x = _padX + 1;
    int y = _padY + 1;

    return Scaffold(

        appBar: AppBar(
          title: Text("Pad $x x $y"),
        ),
        body: Container(
            margin: const EdgeInsets.all(10),
            child: Center(
              child: ListView(
                  // <Widget> is the type of items in the list.
                  children: <Widget>[
                    Text("Sound Clip:", style: TextStyle(fontSize: 16)),
                    Row(
                      children: <Widget>[
                        Text(sampleName),
                        Spacer(),
                        TextButton(onPressed: _onSelectSample, child: Text("Select"))
                      ],
                    ),
                    Divider(),
                    Text("Caption:", style: TextStyle(fontSize: 16)),
                    Row(
                      children: <Widget>[
                        Text(caption),
                        Spacer(),
                        TextButton(onPressed: () {_onChangeCaption(context); }, child: Text("Set"))
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Text("Looped", style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Switch(value: _settings.looped, onChanged: (value){ _settings.looped = value; _settings.save(); setState(() {});})
                      ],
                    ),
                    Divider(),
                    Text("Pad Color:", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    SlidePicker(
                      pickerColor: _settings.color,
                      onColorChanged: (Color color) { _settings.color = color; _settings.save(); },
                      paletteType: PaletteType.rgb,
                      enableAlpha: false,
                      displayThumbColor: true,
                      showLabel: false,
                      ),
                    Divider(),
                    Text("Pad Text Color:", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    SlidePicker(
                      pickerColor: _settings.textColor,
                      onColorChanged: (Color color) { _settings.textColor = color; _settings.save(); },
                      paletteType: PaletteType.rgb,
                      enableAlpha: false,
                      displayThumbColor: true,
                      showLabel: false,
                    ),
                  ]),
            )));
  }

//----------------------------------------------------------------------------
}

//==============================================================================
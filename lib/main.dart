//------------------------------------------------------------------------------
//    main.dart
//    Released under EUPL 1.2
//    Copyright Cherry Tree Studio 2021
//------------------------------------------------------------------------------

import 'package:flutter/material.dart';

import 'padscreen.dart';
import 'settings.dart';

//------------------------------------------------------------------------------

void main()
{
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: PadScreen(defaultSettings),
  ));
}

//------------------------------------------------------------------------------

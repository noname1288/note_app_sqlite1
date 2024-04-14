import 'package:flutter/material.dart';

class NoteSettings extends StatefulWidget {

  @override
  _NoteSettingsState createState() => _NoteSettingsState();
  
}

class _NoteSettingsState extends State<NoteSettings> {
    @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(color: Colors.red, height: 50,),
        Container(color: Colors.green,height: 50),  
        Container(color: Colors.blue,height: 50),
      ]
    );
  }
  
}
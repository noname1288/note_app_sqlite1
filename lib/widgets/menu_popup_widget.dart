import 'package:flutter/material.dart';
import 'package:note_app_1/model/note_model.dart';

class MenuPopupWidget extends StatefulWidget {
  NoteModel? note;
  MenuPopupWidget (this.note);

  @override
  _MenuPopupWidgetState createState() => _MenuPopupWidgetState();
}

class _MenuPopupWidgetState extends State<MenuPopupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.blue,
          ),
          Container(
            height: 50,
            color: Colors.red,
          ),
          Container(
            height: 50,
            color: Colors.amber,
          ),
          ],
      ),
    );
  }
}
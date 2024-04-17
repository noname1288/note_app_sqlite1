import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_1/database/database_service.dart';
import 'package:note_app_1/model/note_model.dart';

final _formKey = GlobalKey<FormState>();

class CreateNote extends StatefulWidget {
  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  DatabaseService db = DatabaseService();

  NoteModel? note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // note's title
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          flexibleSpace: Container(
            color: Colors.deepOrange[300],
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 5),
                    child: Text(
                      'New Note',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // title
                  TextFormField(
                      controller: titleController,
                      validator: (value) =>
                          value!.isEmpty ? 'Title is required' : null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                      ),
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),

                  // content
                  TextFormField(
                    controller: contentController,
                    validator: (value) =>
                        value!.isEmpty ? 'Content is required' : null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Content',
                    ),
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      decorationThickness: 0,
                    ),
                    maxLines: null,
                    clipBehavior: Clip.antiAlias,
                  ),
                  // button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _onSave();
                          }
                        },
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context,'/');
                          },
                          child: const Text('Cancel'))
                    ],
                  ),
                ],
              ),
            )));
  }

  Future<void> _onSave() async {
    final title = titleController.text;
    final content = contentController.text;

    await db.insertNote(NoteModel(
        title: title,
        content: content,
        createAt: DateFormat('dd/MM/yyyy').format(DateTime.now())));

    Navigator.pop(context);
  }
}

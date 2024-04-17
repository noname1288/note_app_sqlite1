import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_1/model/note_model.dart';
import 'package:note_app_1/database/database_service.dart';
import 'package:note_app_1/widgets/menu_popup_widget.dart';
import 'package:popover/popover.dart';

final _formKey = GlobalKey<FormState>();

class EditPage extends StatefulWidget {
  NoteModel? note;

  EditPage(
    this.note,
  );

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  DatabaseService db = DatabaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note!.title;
    _contentController.text = widget.note!.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Text(
          widget.note!.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 167, 146, 211),
        actions: [
          PopupMenuButton<int>(
            iconColor: Colors.white,
            itemBuilder: (context) => [
              // PopupMenuItem 1
              PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete")
                  ],
                ),
              ),
              // PopupMenuItem 2
              PopupMenuItem(
                value: 2,
                // row with two children
                child: Row(
                  children: [
                    Icon(Icons.chrome_reader_mode),
                    SizedBox(
                      width: 10,
                    ),
                    Text("About")
                  ],
                ),
              ),
            ],
            //offset: Offset(0, 100),
            color: Colors.white,
            elevation: 2,
            onSelected: (value) async {
              if (value == 1) {
                await db.deleteNote(id: widget.note!.id!);
              }
              Navigator.popAndPushNamed(context, '/');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // title
                TextFormField(
                    controller: _titleController,
                    validator: (value) =>
                        value!.isEmpty ? 'Title is required' : null,
                    decoration: const InputDecoration(
                        border: InputBorder.none, label: Text('Title')),
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),

                // content
                TextFormField(
                  controller: _contentController,
                  validator: (value) =>
                      value!.isEmpty ? 'Content is required' : null,
                  decoration: const InputDecoration(
                      border: InputBorder.none, label: Text('Content')),
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    decorationThickness: 0,
                  ),
                  maxLines: null,
                  clipBehavior: Clip.antiAlias,
                ),
                // button
                /*ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onEdit();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),*/
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _onEdit();
          }
          Navigator.popAndPushNamed(context, '/home');
        },
        label: Text('Save Note'),
        icon: Icon(Icons.save),
      ),
    );
  }

  Future<void> _onEdit() async {
    final title = _titleController.text;
    final content = _contentController.text;

    await db.updateNote(
      NoteModel(
          id: widget.note!.id,
          updateAt: DateFormat('dd/MM/yyyy').format(DateTime.now()),
          title: title,
          content: content,
          createAt: widget.note!.createAt),
    );
  }
}

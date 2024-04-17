import 'package:flutter/material.dart';
import 'package:note_app_1/model/note_model.dart';
import 'package:note_app_1/screens/home_page.dart';
import 'package:note_app_1/screens/search_page.dart';
import 'package:note_app_1/screens/edit_page.dart';
import 'package:note_app_1/screens/create_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      //theme: ThemeData.dark(),
      home: HomePage(),
      initialRoute: '/', // This is the default route.
      routes: {
        // Define other routes here
        '/search': (context) => SearchPage(),
        
      },
      onGenerateRoute: (settings){
        if (settings.name == '/edit') {
          final NoteModel note = settings.arguments as NoteModel;
          return MaterialPageRoute(builder: (context) {
            return EditPage(note);
          });
        }
        // Handle other routes here
        return null;
      },
    );
  }
}
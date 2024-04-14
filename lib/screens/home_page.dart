import 'package:flutter/material.dart';
import 'package:note_app_1/database/database_service.dart';
import 'package:note_app_1/model/note_model.dart';
import 'package:note_app_1/screens/create_page.dart';
import 'package:note_app_1/screens/edit_page.dart';
import 'package:note_app_1/screens/search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService db = DatabaseService();

  Future<List<NoteModel>> ?allNotes;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() {
    // fetch notes from database
    setState(() {
      allNotes = db.fetchAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          color: Color.fromARGB(255, 58, 103, 139),
          child:
              const Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              'All Notes',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            Flexible(
              child: Text(
                'Total Notes',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              icon: Icon(Icons.search)),
          Expanded(
            child: FutureBuilder(
                future: allNotes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No Note Found'),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: snapshot.requireData.length,
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 5,
                            margin: EdgeInsets.all(5),
                            child: ListTile(
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(
                                    // function to compare updateAt and createAt
                                    snapshot.requireData[index].updateAt == null
                                        ? '${snapshot.requireData[index].createAt}'
                                        : '${snapshot.requireData[index].updateAt}'),
                                trailing: IconButton(
                                    onPressed: ()async{
                                      await db.deleteNote(id: snapshot.requireData[index].id!);
                                      fetchNotes();
                                    },
                                    icon: const Icon(Icons.delete)),
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EditPage(
                                                  snapshot.requireData[index])))
                                      .then((value) => fetchNotes());
                                } // go to editing page,
                              
                                ),
                          
                        );
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromARGB(255, 172, 195, 234),
        onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateNote()))
            .then((value) => fetchNotes()),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  Future<void> delete_by_index(int id) async {
    await db.deleteNote(id: id);
  }
}

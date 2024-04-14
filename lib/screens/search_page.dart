import 'package:flutter/material.dart';
import 'package:note_app_1/database/database_service.dart';
import 'package:note_app_1/model/note_model.dart';
import 'package:note_app_1/screens/edit_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<NoteModel> notes = [
    NoteModel(
      title: "Meeting Notes",
      content: "Discuss project deadline and next steps.",
      createAt: DateTime.now().toString(),
    ),

    // 2. Grocery list
    NoteModel(
      title: "Grocery List",
      content: "Milk, Bread, Eggs, Apples, Bananas",
      createAt: DateTime.now().toString(),
    ),

    // 3. To-do list
    NoteModel(
      title: "To-Do List",
      content: "- Finish flutter tutorial\n- Buy birthday gift for friend",
      createAt: DateTime.now().toString(),
    ),

    // 4. Book quote
    NoteModel(
      title: "Book Quote",
      content:
          "\"The journey of a thousand miles begins with a single step.\" - Lao Tzu",
      createAt: DateTime.now().toString(),
    ),

    // 5. App Idea
    NoteModel(
      title: "App Idea",
      content: "Develop a language learning app with interactive exercises.",
      createAt: DateTime.now().toString(),
    ),

    // 6. Important reminder
    NoteModel(
      title: "Important!",
      content: "Call Mom on her birthday (April 15th)",
      createAt: DateTime.now().toString(),
    ),

    // 7. Class notes
    NoteModel(
      title: "Biology Class - Chapter 5",
      content: "Key points: Photosynthesis, cellular respiration...",
      createAt: DateTime.now().toString(),
    ),

    // 8. Password note (not recommended for actual passwords!)
    // **Security Note:** It's not recommended to store actual passwords in plain text.
    NoteModel(
      title: "Fake Password",
      content: "This is not a real password (for demonstration purposes only)",
      createAt: DateTime.now().toString(),
    ),

    // 9. Inspirational quote
    NoteModel(
      title: "Quote of the Day",
      content:
          "\"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.\" - Helen Keller",
      createAt: DateTime.now().toString(),
    ),

    // 1  Shopping list
    NoteModel(
      title: "Shopping List",
      content: "- Laptop charger\n- Headphones\n- Water bottle",
      createAt: DateTime.now().toString(),
    ),
  ];

  final DatabaseService db = DatabaseService();
  Future<List<NoteModel>>? sugestNotes;  

  SearchController searchController = SearchController();

  // @override
  // void initState() {
  //   super.initState();
  //   sugestNotes = db.fetchAllNotes();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Search Notes')),
        body: Column(
          children: [
            // search bar
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 30),
              child: TextFormField(
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  decorationThickness: 0,
                ),
                controller: searchController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none),
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: searchController.text.isEmpty ? null : IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                        })),
                onChanged: (value){
                  setState(() {
                    sugestNotes = db.searchNote(value);
                  });
                },
              ),
            ),

            // History
            Expanded(
              child: FutureBuilder(
                future: sugestNotes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  }
                  else if (!snapshot.hasData) {
                    return const Center(child: Text('No Note Found'));
                  }
                  return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> EditPage(snapshot.data![index])));
                      },
                      trailing:const Icon(Icons.arrow_outward),
                    );
                  },
                );
                }
              ),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:note_keeper_flutter/Model/note.dart';
import 'package:note_keeper_flutter/MyDatabase/database_helper.dart';
import 'package:note_keeper_flutter/Pages/note_add_edit.dart';
import 'package:note_keeper_flutter/Pages/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count;
  @override
  void initState() {
    super.initState();
    count = 0;
    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
  
  Color getPriorityColor(int p){
    Color color;
    switch(p){
      case 1 :
        color = Colors.red;
        break;
      case 2 :
        color = Colors.blueAccent;
        break;
      case 3 : 
        color = Colors.green;
        break;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "Edit",
          onPressed: () async{
            bool result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NoteEditPage(appBarTitle: "Add Note",note: Note('', '', 2),)
            )
            );
            if(result == true)
              updateListView();
          },
          child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.cover)),
        child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext ctx,int index){
              Note note = noteList[index];
              return Card(
                color: Colors.transparent,
                elevation: 10.0,
                child: Container(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getPriorityColor(note.priority),
                      child: Text(note.title[0].toUpperCase()),
                    ),
                    title: Text(note.title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    trailing: Text(note.date,style: TextStyle(color: Colors.white),),
                    onTap: () async{
                      bool result = await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteDetail(note: note)
                      ));
                      if(result == true)
                        updateListView();
                    },
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_keeper_flutter/Model/note.dart';
import 'package:note_keeper_flutter/MyDatabase/database_helper.dart';
import 'package:note_keeper_flutter/Pages/note_add_edit.dart';

class NoteDetail extends StatefulWidget {

  final Note note;

  const NoteDetail({Key key, this.note}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {

  static var _priorities = ['High','Medium','Low'];
  Note note;
  DatabaseHelper helper;
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
      case 3:
        priority = _priorities[2];
        break;
    }
    return priority;
  }
  @override
  void initState() {
    super.initState();
    note = widget.note;
    helper = DatabaseHelper();
  }

  void moveToLastPage(bool res){
    Navigator.pop(context,res);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        moveToLastPage(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Note Details"),
          backgroundColor: Colors.amber,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => moveToLastPage(false)
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "Edit",
              backgroundColor: Colors.green,
              onPressed: () async{
                bool result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => NoteEditPage(note: note,appBarTitle: "Edit Note",)
                    ));
                if(result == true)
                  moveToLastPage(true);
              },
              child: Icon(Icons.edit,color: Colors.white,),
            ),
            SizedBox(height: 20.0,),
            FloatingActionButton(
              onPressed: () async{
                int result;
                result = await helper.deleteNote(note);
                Navigator.pop(context,true);
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.delete,color: Colors.white,),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.cover)),
          child: ListView(
            children: <Widget>[
              Text(
                "Title : ${note.title}",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                "Priority : ${getPriorityAsString(note.priority)}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.brown[700],width: 3.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "Description : ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0
                          ),
                      ),
                      Text(
                          note.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 25.0
                          ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Text(
                  "Last Updated On : ${note.date}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

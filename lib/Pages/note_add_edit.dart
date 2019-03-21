import 'package:flutter/material.dart';
import 'package:note_keeper_flutter/Model/note.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper_flutter/MyDatabase/database_helper.dart';

class NoteEditPage extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  const NoteEditPage({Key key, this.appBarTitle, this.note}) : super(key: key);

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {

  static var _priorities = ['High','Medium','Low'];
  String title,description;
  Note note;
  DatabaseHelper helper;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    helper = DatabaseHelper();
    note = widget.note;
    title = note.title;
    description = note.description;
  }
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Medium':
        note.priority = 2;
        break;
      case 'Low':
        note.priority = 3;
        break;
    }
  }

  void moveToLastPage(bool res){
    Navigator.pop(context,res);
  }

  // Convert int priority to String priority and display it to user in DropDown
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

  void _save() async{
    final form = formKey.currentState;
    int result;
    if(form.validate()){
      form.save();
      note.title = title;
      note.description = description;
      note.date = DateFormat.yMMMd().format(DateTime.now());
      if(note.id != null)
        result = await helper.updateNote(note);
      else
        result = await helper.insertNote(note);
      moveToLastPage(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        moveToLastPage(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => moveToLastPage(false)
          ),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Priority"),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: DropdownButton(
                    items: _priorities.map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                    )).toList(),
                    value: getPriorityAsString(note.priority),
                    onChanged: (newValue){
                      setState(() {
                        updatePriorityAsInt(newValue);
                      });
                    }
                ),
              ),
            ),
            Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))
                        ),
                        maxLength: 50,
                        validator: (value) => !((value.length) > 0)?"Title can't be empty":null,
                        onSaved: (value) => title = value,
                        initialValue: title,
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                            labelText: "Description",
                        ),
                        maxLength: 300,
                        onSaved: (value) => description = value,
                        initialValue: description,
                      )
                    ],
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: _save,
                      splashColor: Colors.orange,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.green,Colors.yellow]),
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic,color: Colors.purple),
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

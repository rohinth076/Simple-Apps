import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:take_notes/models/note.dart';
import 'package:take_notes/utils/database_helper.dart';

class NoteDetails extends StatefulWidget{
  final String title;
  final Note note;

  NoteDetails(this.title, this.note);

  @override
  State<StatefulWidget> createState() {
    return _Details(title,note);
  }
}

class _Details extends State<NoteDetails>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  var _formKey = GlobalKey<FormState>();


  TextEditingController tc = new TextEditingController();
  TextEditingController dc = new TextEditingController();

  String title;
  Note note;

  _Details(this.title, this.note);

  @override
  Widget build(BuildContext context) {
    tc.text = note.title;
    dc.text = note.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return WillPopScope(
        onWillPop: (){
          moveBackWard();
        },
      child :Scaffold(
      appBar: AppBar(
       title : Text(title),
      ),
      body:Form(
        key : _formKey,
      child : Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                controller: tc,
                style: textStyle,
                // ignore: missing_return
                validator:(String value){
                  if(value.trim().isEmpty)
                     return 'Please enter Title';
                },
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  ),

                ),
               )

              ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: dc,
                style: textStyle,
                decoration: InputDecoration(
                    hintText: 'Enter Description',
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),

              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: [
                   Expanded(
                     child: RaisedButton(
                       color: Colors.green,
                       child: Text('Save'),
                       onPressed: (){
                         if(_formKey.currentState.validate())
                              _save();
                       },
                     ),
                   ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.red,
                        child: Text('Delete'),
                        onPressed: (){
                         _delete();
                        },
                      ),
                    )
                  ],
                ),
            )
          ],
        )
    )
    ))
    );
  }

  void moveBackWard(){
    Navigator.pop(context,true);
  }

  void updateTitle(){
    note.title = tc.text;

  }

  void updateDescription(){
    note.description = dc.text;
  }
  void _save() async{
    moveBackWard();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    updateTitle();
    updateDescription();
    int result;
    if(note.id == null){
      result = await DatabaseHelper().insertNote(note);
    }
    else{
      result = await databaseHelper.updateNote(note);
    }

    if(result != 0){
      _showAlertDialog('Status', 'Saved Successfully');
    }
    else{
      _showAlertDialog('Status', 'Problem in saving');
    }
  }

  void _delete() async{
    moveBackWard();
    if(note.id == null){
      _showAlertDialog('Status', 'No note was deleted');
      return;
    }
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0){
      _showAlertDialog('Status', 'Note delete successfully');
    }
    else{
      _showAlertDialog('Status', 'Problem in deleting');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}
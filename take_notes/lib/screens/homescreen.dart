import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:take_notes/models/note.dart';
import 'package:take_notes/screens/note_details.dart';
import 'package:take_notes/utils/database_helper.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return MyHomeScreen();
  }

}

class MyHomeScreen extends State<HomeScreen>{
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count =0;
  List<Note> list;
  @override
  Widget build(BuildContext context) {
    if(list == null){
      // ignore: deprecated_member_use
      list = List<Note>();
    }
    updateListView();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: SafeArea(
        child: getListView()
      ),

      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            moveForWard('Add Notes',Note('',''));
          }
        ),
        tooltip: 'Add Notes',
      ),
    );

  }
ListView getListView(){
     TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context,int position){
        return Card(
          color: Colors.white,
          elevation: 3.0,
          child: ListTile(
            title: Text(this.list[position].title,style: titleStyle),
            subtitle: Text(this.list[position].date,style: titleStyle),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: (){
                _delete(context, list[position]);
              },


            ),
            onTap: (){
              moveForWard('Edit Notes', list[position]);
            },
          )
        );
      },
    );
}
void moveForWard(String title,Note note)async{
   bool val = await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetails(title,note)));

   if(val == true){
     updateListView();
   }
}

  void _delete(BuildContext context,Note note) async{
    int result = await databaseHelper.deleteNote(note.id);

    if(result !=0){
      _showSnackBar(context, "Note delete successfully");
      updateListView();
    }
  }


  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }


  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.database;
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.list = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

}
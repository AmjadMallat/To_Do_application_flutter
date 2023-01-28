import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/dialog_box.dart';

import '../util/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //reference the box
  final _myBox=Hive.box('myBox');
  toDoDataBase db=toDoDataBase();

@override
  void initState() {
   //if awl mra byft7 l app create a default data
   if(_myBox.get("TODOLIST")==null){
    db.createInitialData();
   }
   else{
    //so 7et data tb3ito load
    db.loadData();
   }


    super.initState();
  }

//text controller
final _controller=TextEditingController();



//check box was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      //bt8ayer check box bt3kesa

      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  //he funcation la n3ml save w add la new task
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

//ra7 n3ml function la n3ml create la new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  //function la n3ml delete la task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'TO DO',
          style: TextStyle(),
        ),
        elevation: 0,
      ),
//la n3ml add la w7de jdide mn5l2 button jdid
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoList(
            taskname: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}

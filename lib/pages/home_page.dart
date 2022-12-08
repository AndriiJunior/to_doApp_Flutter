import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;

  String? _newTaskContent;
  Box? _box;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        title: Text(
          "To Do",
          style: TextStyle(fontSize: 50),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTask(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox('task'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _tasksList();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _tasksList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]);
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            ListTile(
              title: Text(
                task.content,
                style: TextStyle(
                  decoration: task.done ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(task.timestemp.toString()),
              trailing: Icon(
                task.done
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: Colors.red,
              ),
              onTap: () {
                setState(() {
                  task.done = !task.done;
                  _box!.putAt(_index, task.toMap());
                });
              },
              onLongPress: () {
                _box!.deleteAt(_index);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget _addTask() {
    return FloatingActionButton(
      onPressed: _displayTaskPopUp,
      child: Icon(Icons.add),
    );
  }

  void _displayTaskPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text("Add New Task"),
          content: TextField(
            onSubmitted: (_) {
              if (_newTaskContent != null) {
                var _task = Task(
                    content: _newTaskContent!,
                    timestemp: DateTime.now(),
                    done: false);
                _box!.add(_task.toMap());

                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
              ;
            },
            onChanged: (_value) {
              setState(() {
                _newTaskContent = _value;
              });
            },
          ),
        );
      },
    );
  }
}

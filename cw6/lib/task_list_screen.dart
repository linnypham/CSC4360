import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseReference _tasksRef =
      FirebaseDatabase.instance.ref().child('tasks');
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      _tasksRef.push().set({
        'name': _taskController.text,
        'completed': false,
      });
      _taskController.clear();
    }
  }

  void _toggleCompletion(String taskId, bool currentStatus) {
    _tasksRef.child(taskId).update({'completed': !currentStatus});
  }

  void _deleteTask(String taskId) {
    _tasksRef.child(taskId).remove();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration:
                        InputDecoration(labelText: 'Enter a new task'),
                  ),
                ),
                ElevatedButton(onPressed: _addTask, child: Text('Add')),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _tasksRef.onValue,
              builder:
                  (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No tasks available.'));
                }
                final tasks = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final taskId = tasks.keys.elementAt(index);
                    final task = tasks[taskId];
                    return ListTile(
                      title:
                          Text(task['name'], style:
                              TextStyle(decoration:
                                  task['completed'] ? TextDecoration.lineThrough : null)),
                      leading:
                          Checkbox(value:
                              task['completed'], onChanged:
                              (value) => _toggleCompletion(taskId, task['completed'])),
                      trailing:
                          IconButton(icon:
                              Icon(Icons.delete), onPressed:
                              () => _deleteTask(taskId)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

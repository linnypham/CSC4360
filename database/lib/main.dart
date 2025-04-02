import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DB Viwer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    dbHelper.init().then((_) {
      _refreshRecords();
    });
  }

  void _refreshRecords() {
    dbHelper.queryAllRows().then((records) {
      setState(() {
        _records = records;
      });
    });
  }

  void _addRecord() {
    final name = nameController.text;
    final age = int.tryParse(ageController.text) ?? 0;
    if (name.isNotEmpty && age > 0) {
      dbHelper.insert({
        DatabaseHelper.columnName: name,
        DatabaseHelper.columnAge: age,
      }).then((_) {
        _refreshRecords();
        nameController.clear();
        ageController.clear();
      });
    }
  }

  void _deleteRecord(int id) {
    dbHelper.delete(id).then((_) {
      _refreshRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: _addRecord,
            child: Text('Add Record'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return ListTile(
                  title: Text(record[DatabaseHelper.columnName]),
                  subtitle: Text('Age: ${record[DatabaseHelper.columnAge]}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteRecord(record[DatabaseHelper.columnId]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

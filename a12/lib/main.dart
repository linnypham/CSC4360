import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryHomePage(),
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key});

  @override
  _InventoryHomePageState createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Management"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("Quantity: ${doc['quantity']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _updateItemDialog(doc),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => FirebaseFirestore.instance.collection('items').doc(doc.id).delete(),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addItemDialog(),
      ),
    );
  }

  void _addItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('items').add({
                  'name': _nameController.text,
                  'quantity': int.parse(_quantityController.text),
                });
                _nameController.clear();
                _quantityController.clear();
              }
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _updateItemDialog(DocumentSnapshot doc) {
    _nameController.text = doc['name'];
    _quantityController.text = doc['quantity'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('items').doc(doc.id).update({
                  'name': _nameController.text,
                  'quantity': int.parse(_quantityController.text),
                });
                _nameController.clear();
                _quantityController.clear();
              }
              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}

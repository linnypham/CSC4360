import 'package:flutter/material.dart';
import '../pages/chat_page.dart';
import '../widgets/drawer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> boards = const [
    {
      'id': 'general',
      'name': 'General',
      'icon': Icons.chat_bubble_outline,
    },
    {
      'id': 'computer',
      'name': 'Computer Class',
      'icon': Icons.computer,
    },
    {
      'id': 'mobile',
      'name': 'Mobile Dev Class',
      'icon': Icons.smartphone,
    },
    {
      'id': 'random',
      'name': 'Random',
      'icon': Icons.emoji_emotions_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message Boards"),
      ),
      drawer: const DrawerWidget(displayName: "Student"),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(board['icon'] as IconData, size: 30),
              title: Text(board['name'], style: const TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      boardId: board['id'],
                      boardName: board['name'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

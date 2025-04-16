import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message Board App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthGate()));
    });
    return Scaffold(
      body: Center(child: Text('Welcome to Message Board', style: TextStyle(fontSize: 24))),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        if (snapshot.hasData) return MessageBoardHome();
        return LoginPage();
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
              child: Text('No account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name')),
              TextField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'role': 'user',
                      'registrationDate': Timestamp.now(),
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBoardHome extends StatelessWidget {
  final List<Map<String, dynamic>> boards = [
    {'name': 'General', 'icon': Icons.chat},
    {'name': 'Tech Talk', 'icon': Icons.computer},
    {'name': 'Random', 'icon': Icons.casino},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text('Menu', style: TextStyle(color: Colors.white)), decoration: BoxDecoration(color: Colors.blue)),
            ListTile(title: Text('Message Boards'), onTap: () => Navigator.pop(context)),
            ListTile(title: Text('Profile'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()))),
            ListTile(title: Text('Settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()))),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(boards[index]['icon']),
          title: Text(boards[index]['name']),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatPage(boardName: boards[index]['name'])),
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String boardName;
  final TextEditingController messageController = TextEditingController();

  ChatPage({required this.boardName});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final messagesRef = FirebaseFirestore.instance.collection('boards').doc(boardName).collection('messages').orderBy('timestamp');

    return Scaffold(
      appBar: AppBar(title: Text(boardName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['message'] ?? ''),
                      subtitle: Text('${data['user'] ?? 'anon'} • ${data['timestamp'].toDate()}'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: messageController, decoration: InputDecoration(hintText: 'Type a message'))),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      FirebaseFirestore.instance.collection('boards').doc(boardName).collection('messages').add({
                        'message': messageController.text.trim(),
                        'user': user?.email ?? 'anon',
                        'timestamp': Timestamp.now(),
                      });
                      messageController.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Profile')), body: Center(child: Text('Profile of ${user?.email ?? 'Unknown'}')));
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AuthGate()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

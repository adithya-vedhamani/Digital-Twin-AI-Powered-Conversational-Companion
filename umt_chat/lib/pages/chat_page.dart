import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the User List Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserListPage()),
            );
          },
          child: Text("Go to Chat"), // THIS BUTTON NOW GOES TO UserListPage
        ),
      ),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.4:8000/users/'));
      if (response.statusCode == 200) {
        setState(() {
          users = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print("Failed to fetch users");
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['name']),
                  onTap: () {
                    // Navigate to Chat Page for the selected user
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userId: users[index]['id'],
                          userName: users[index]['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final int userId;
  final String userName;

  ChatPage({required this.userId, required this.userName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add("You: $message");
    });
    _messageController.clear();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:8000/simulate/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"user_id": widget.userId, "message": message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          messages.add("${widget.userName} AI: ${data['response']}");
        });
      } else {
        setState(() {
          messages.add("Error: Unable to fetch response");
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Error: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.userName} AI")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

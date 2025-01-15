import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'chat_page.dart'; // Import the ChatPage

class UserListPage extends StatefulWidget {
  final int userId;

  UserListPage({required this.userId});

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
    final response =
        await http.get(Uri.parse('http://192.168.1.6:8000/users/'));
    if (response.statusCode == 200) {
      setState(() {
        users = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print("Failed to fetch users");
    }
  }

  // Helper function to handle null or missing values
  String _getDetailOrPlaceholder(String? detail, String placeholder) {
    return detail != null && detail.isNotEmpty ? detail : placeholder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select User to Chat"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigoAccent[100],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      user['name'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _getDetailOrPlaceholder(
                          user['age']?.toString(), 'No age details available'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _getDetailOrPlaceholder(
                          user['sex'], 'No education details available'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _getDetailOrPlaceholder(
                          user['location'], 'No location details available'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _getDetailOrPlaceholder(
                          user['education'], 'No eductaion details available'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _getDetailOrPlaceholder(user['professional_details'],
                          'No professional details available'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to ChatPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              userId: user['id'],
                              userName: user['name'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Chat Now",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

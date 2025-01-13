import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_list_page.dart';  // Import the UserListPage

class QuestionnairePage extends StatefulWidget {
  final int userId;
  final String userName;

  QuestionnairePage({required this.userId, required this.userName});

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _questionController = TextEditingController();
  final List<String> questions = [
    "How are you feeling today?",
    "What motivates you the most?",
    "What is your favorite hobby?",
    "Describe yourself in one word."
  ];
  int currentQuestionIndex = 0;
  Map<String, String> responses = {};

  Future<void> _submitResponses() async {
    final List<Map<String, dynamic>> entries = responses.entries
        .map((entry) => {
              'user_id': widget.userId,
              'question': entry.key,
              'response': entry.value,
            })
        .toList();

    final body = json.encode({'user_id': widget.userId, 'entries': entries});

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:8000/personality/'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryPage(
                responses: responses,
                userId: widget.userId,
                userName: widget.userName),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit responses')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server: $e')),
      );
    }
  }

  void _nextQuestion() {
    final userResponse = _questionController.text;

    if (userResponse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a response')),
      );
      return;
    }

    setState(() {
      responses[questions[currentQuestionIndex]] = userResponse;
      _questionController.clear();

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _submitResponses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Questionnaire")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questions[currentQuestionIndex],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Your response',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(
                currentQuestionIndex < questions.length - 1
                    ? 'Next'
                    : 'Submit All',
              ),
            ),
            Spacer(), // Pushes the button to the bottom
            ElevatedButton(
              onPressed: () {
                // Navigate to the User List Page to choose a user to chat with
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(userId: widget.userId),
                  ),
                );
              },
              child: Text('Go to Chat'),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryPage extends StatelessWidget {
  final Map<String, String> responses;
  final int userId;
  final String userName;

  SummaryPage(
      {required this.responses, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User: $userName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("User ID: $userId", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Responses: ", style: TextStyle(fontSize: 18)),
            ...responses.entries.map((entry) {
              return Text("${entry.key}: ${entry.value}",
                  style: TextStyle(fontSize: 16));
            }).toList(),
          ],
        ),
      ),
    );
  }
}

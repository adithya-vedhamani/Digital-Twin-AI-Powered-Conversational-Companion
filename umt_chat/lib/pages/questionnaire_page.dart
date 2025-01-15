import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_list_page.dart';

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

  double get progress => (currentQuestionIndex + 1) / questions.length;

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
        Uri.parse('http://192.168.1.6:8000/personality/'),
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
              userName: widget.userName,
            ),
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
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Center(
          child: Text(
            "Personality Assessment Questionnaire",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.indigoAccent[50], // Light indigoAccent background
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        questions[currentQuestionIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigoAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          labelText: 'Your response',
                          filled: true,
                          fillColor: Colors.indigoAccent[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          currentQuestionIndex < questions.length - 1
                              ? 'Next'
                              : 'Submit All',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of ${questions.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigoAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.indigoAccent[100],
                    color: Colors.indigoAccent,
                    minHeight: 8,
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryPage extends StatelessWidget {
  final Map<String, String> responses;
  final int userId;
  final String userName;

  SummaryPage({
    required this.responses,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Center(
          child: Text(
            "Summary Section",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.indigoAccent[50],
          child: SingleChildScrollView(
            // Added scrollable container
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary for $userName",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "User ID: $userId",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Responses:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Prevent nested scrolling
                      itemCount: responses.length,
                      itemBuilder: (context, index) {
                        String question = responses.keys.elementAt(index);
                        String response = responses.values.elementAt(index);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.indigoAccent),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigoAccent,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                response,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to user list page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListPage(userId: userId),
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
                      child: Text("Go to User List"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String userName;

  ChatPage({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("Chat Page"),
      ),
      body: Center(
        child: Text(
          "Welcome to the Chat, $userName!",
          style: TextStyle(fontSize: 18, color: Colors.indigoAccent),
        ),
      ),
    );
  }
}

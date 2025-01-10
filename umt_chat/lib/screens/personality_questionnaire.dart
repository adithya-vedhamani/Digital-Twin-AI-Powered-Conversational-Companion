import 'package:flutter/material.dart';
import 'package:umt_chat/services/api_service.dart';
import 'package:umt_chat/models/personality.dart';
import 'package:umt_chat/screens/message_simulation.dart'; // Add this import

class PersonalityQuestionnaire extends StatefulWidget {
  final int userId;

  PersonalityQuestionnaire({required this.userId});

  @override
  _PersonalityQuestionnaireState createState() =>
      _PersonalityQuestionnaireState();
}

class _PersonalityQuestionnaireState extends State<PersonalityQuestionnaire> {
  final ApiService _apiService = ApiService();
  final List<String> questions = [
    "How do you introduce yourself to new people?",
    "What kind of people do you like to talk to?",
    "How would you politely decline an offer you’re not interested in?",
    "What's your favorite way to start a conversation?",
    "How do you respond to compliments?"
  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var question in questions) {
      _controllers[question] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personality Questionnaire")),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(questions[index]),
                TextFormField(
                  controller: _controllers[questions[index]],
                  decoration: InputDecoration(hintText: 'Your response'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitPersonality,
        child: Icon(Icons.save),
      ),
    );
  }

  void _submitPersonality() async {
    for (var question in questions) {
      if (_controllers[question]!.text.isEmpty) {
        // Show error if any answer is empty
        return;
      }

      PersonalityEntry entry = PersonalityEntry(
        userId: widget.userId,
        question: question,
        response: _controllers[question]!.text,
      );

      try {
        await _apiService.addPersonalityEntry(entry);
      } catch (e) {
        print("Error: $e");
      }
    }

    // Navigate to message simulation screen after questionnaire is completed
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessageSimulation(userId: widget.userId)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:umt_chat/services/api_service.dart';

class MessageSimulation extends StatefulWidget {
  final int userId;

  MessageSimulation({required this.userId});

  @override
  _MessageSimulationState createState() => _MessageSimulationState();
}

class _MessageSimulationState extends State<MessageSimulation> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  String response = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Simulate Message")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: "Enter a message"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateMessage,
              child: Text("Send Message"),
            ),
            SizedBox(height: 20),
            if (response.isNotEmpty) Text("Response: $response"),
          ],
        ),
      ),
    );
  }

  void _simulateMessage() async {
    try {
      var simulatedResponse = await _apiService.simulateResponse(
          widget.userId, _messageController.text);
      setState(() {
        response = simulatedResponse['response'];
      });
    } catch (e) {
      print("Error: $e");
    }
  }
}

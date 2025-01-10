import 'package:flutter/material.dart';
import 'package:umt_chat/services/api_service.dart';
import 'package:umt_chat/models/user.dart';
import 'package:umt_chat/models/personality.dart';
import 'package:umt_chat/screens/message_simulation.dart';
import 'package:umt_chat/screens/personality_questionnaire.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  int? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Onboarding")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your age" : null,
              ),
              TextFormField(
                controller: _sexController,
                decoration: InputDecoration(labelText: "Sex"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your sex" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your location" : null,
              ),
              TextFormField(
                controller: _educationController,
                decoration: InputDecoration(labelText: "Education"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your education" : null,
              ),
              TextFormField(
                controller: _professionController,
                decoration: InputDecoration(labelText: "Professional Details"),
                validator: (value) => value!.isEmpty
                    ? "Please enter your professional details"
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        sex: _sexController.text,
        location: _locationController.text,
        education: _educationController.text,
        professionalDetails: _professionController.text,
      );

      try {
        var response = await _apiService.createUser(user);
        userId = response['user_id'];
        // Navigate to next screen after user is created
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PersonalityQuestionnaire(userId: userId!)),
        );
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:umt_chat/models/user.dart';
import 'package:umt_chat/pages/questionnaire_page.dart';
import 'package:umt_chat/services/api_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _locationController = TextEditingController();
  final _educationController = TextEditingController();
  final _professionalDetailsController = TextEditingController();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        sex: _sexController.text,
        location: _locationController.text,
        education: _educationController.text,
        professionalDetails: _professionalDetailsController.text,
      );

      try {
        final response = await _apiService.createUser(user);

        // Pass userId and name to QuestionnairePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionnairePage(
              userId: response['user_id'],
              userName: _nameController.text,  // Pass name here
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Signup failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Age is required' : null,
              ),
              TextFormField(
                controller: _sexController,
                decoration: InputDecoration(labelText: 'Sex'),
                validator: (value) => value!.isEmpty ? 'Sex is required' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value!.isEmpty ? 'Location is required' : null,
              ),
              TextFormField(
                controller: _educationController,
                decoration: InputDecoration(labelText: 'Education'),
                validator: (value) =>
                    value!.isEmpty ? 'Education is required' : null,
              ),
              TextFormField(
                controller: _professionalDetailsController,
                decoration: InputDecoration(labelText: 'Professional Details'),
                validator: (value) =>
                    value!.isEmpty ? 'Professional Details are required' : null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

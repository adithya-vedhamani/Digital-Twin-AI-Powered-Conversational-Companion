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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionnairePage(
              userId: response['user_id'],
              userName: _nameController.text,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign Up'),
      //   centerTitle: true,
      //   backgroundColor: Colors.indigo,
      //   elevation: 0,
      // ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade300, Colors.indigo.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Text(
                    "Please fill in the details below to create your account.",
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  icon: Icons.person,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _ageController,
                  labelText: 'Age',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _sexController,
                  labelText: 'Sex',
                  icon: Icons.wc,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _locationController,
                  labelText: 'Location',
                  icon: Icons.location_on,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _educationController,
                  labelText: 'Education',
                  icon: Icons.school,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _professionalDetailsController,
                  labelText: 'Professional Details',
                  icon: Icons.work,
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2,
                        vertical: screenHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigoAccent,
                      textStyle: TextStyle(
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icon != null ? Icon(icon, color: Colors.indigo) : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.indigo),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.indigo, width: 2),
            ),
          ),
          keyboardType: keyboardType,
          validator: (value) =>
              value!.isEmpty ? '$labelText is required' : null,
        ),
      ],
    );
  }
}

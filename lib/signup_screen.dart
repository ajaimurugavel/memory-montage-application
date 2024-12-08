import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientEmailController = TextEditingController();
  final TextEditingController _patientPhoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianRelationshipController = TextEditingController();
  final TextEditingController _guardianEmailController = TextEditingController();
  final TextEditingController _guardianPhoneNumberController = TextEditingController(); // Added guardian phone number field
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up for Memory Montage'),
        backgroundColor: const Color.fromARGB(255, 37, 209, 243),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _patientEmailController,
                decoration: const InputDecoration(
                  labelText: 'Patient Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _patientPhoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Patient Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _guardianNameController,
                decoration: const InputDecoration(
                  labelText: 'Guardian Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _guardianRelationshipController,
                decoration: const InputDecoration(
                  labelText: 'Guardian Relationship',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _guardianEmailController,
                decoration: const InputDecoration(
                  labelText: 'Guardian Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _guardianPhoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Guardian Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your signup logic here
                  String patientName = _patientNameController.text;
                  String patientEmail = _patientEmailController.text;
                  String patientPhoneNumber = _patientPhoneNumberController.text;
                  String age = _ageController.text;
                  String guardianName = _guardianNameController.text;
                  String guardianRelationship = _guardianRelationshipController.text;
                  String guardianEmail = _guardianEmailController.text;
                  String guardianPhoneNumber = _guardianPhoneNumberController.text; // Added guardian phone number
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;

                  // Perform signup validation or API call here

                  // For simplicity, just print the details for now
                  print('Patient Name: $patientName');
                  print('Patient Email: $patientEmail');
                  print('Patient Phone Number: $patientPhoneNumber');
                  print('Age: $age');
                  print('Guardian Name: $guardianName');
                  print('Guardian Relationship: $guardianRelationship');
                  print('Guardian Email: $guardianEmail');
                  print('Guardian Phone Number: $guardianPhoneNumber');
                  print('Password: $password');
                  print('Confirm Password: $confirmPassword');

                  // You can add logic here to send signup details to the guardian's email
                  // For simplicity, print a message
                  print('Account created for $patientName. Guardian will receive an email.');

                  // Navigate to the sign-in screen
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 37, 209, 243),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

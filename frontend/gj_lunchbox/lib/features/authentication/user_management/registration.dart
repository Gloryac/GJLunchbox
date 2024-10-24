import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Update the user's profile to include display name
      await userCredential.user
          ?.updateProfile(displayName: _displayNameController.text.trim());

      // Reload the user to apply the changes
      await userCredential.user?.reload();

      print("Registered: ${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message; // Set the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Full Name",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            _buildTextField(
              controller: _displayNameController,
              hintText: "John Doe",
            ),
            SizedBox(height: 16),
            Text(
              "Email Address",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hintText: "example@gmail.com",
            ),
            SizedBox(height: 16),
            Text(
              "Password",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            _buildPasswordField(),
            SizedBox(height: 8),
            Text(
              "Case sensitive",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            _buildTermsCheckbox(),
            SizedBox(height: 16),
            _buildSignUpButton(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate back to the login page if needed
                // Navigator.pop(context);
              },
              child: Text('Already have an account? Login!'),
            ),
          ],
        ),
      ),
    );
  }

  // TextField Widget with common styling
  Widget _buildTextField(
      {required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]), // Placeholder color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
        ),
      ),
    );
  }

  // Password field with toggle visibility
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "********",
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
        ),
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  // Terms of Services Checkbox
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (bool? value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Wrap(
            children: [
              Text("I agree to the "),
              GestureDetector(
                onTap: () {
                  // Handle terms of service tap
                },
                child: Text(
                  "Terms of Services",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              Text(" and "),
              GestureDetector(
                onTap: () {
                  // Handle privacy policy tap
                },
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Signup Button
  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_agreeToTerms) {
            // Perform sign-up
          } else {
            // Show error
          }
        },
        style: ElevatedButton.styleFrom(
          // primary: Colors.green, // Background color
          padding: EdgeInsets.symmetric(vertical: 16), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        child: Text("Sign Up"),
      ),
    );
  }
}

import 'package:dj_lunchbox/features/authentication/user_management/registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './utils/BuildPasswordField.dart';
import './utils/BuildTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  final bool _obscurePassword = true;

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Successfully logged in
      print("Logged in: ${userCredential.user?.email}");
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email Address",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: _emailController,
              hintText: "example@gmail.com",
            ),
            SizedBox(height: 16),
            Text(
              "Password",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            PasswordField(controller: _passwordController),
            SizedBox(height: 8),
            Text(
              "Case sensitive",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            _buildErrorMessage(),
            SizedBox(height: 16),
            _buildLoginButton(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to sign-up page if needed
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationPage()));
              },
              child: Text('Don’t have an account? Sign Up!'),
            ),
          ],
        ),
      ),
    );
  }

  // Display error message
  Widget _buildErrorMessage() {
    return _errorMessage != null
        ? Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red),
          )
        : SizedBox.shrink();
  }

  // Login Button
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Perform login
          login();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        child: Text("Login"),
      ),
    );
  }
}

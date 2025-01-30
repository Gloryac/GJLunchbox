import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dj_lunchbox/features/authentication/user_management/login.dart';
import 'package:dj_lunchbox/features/home/screen/home.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/constants/sizes.dart';

import './utils/BuildPasswordField.dart';
import './utils/BuildTextField.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  String? _errorMessage;
  final bool _obscurePassword = true;
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

      // Create Firestore user document
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
        'displayName': _displayNameController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("Registered: ${userCredential.user?.email}");
      // Navigate to Account Setup Screen
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message; // Set the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TextStrings.signUp,
              style: AppTextTheme.textStyles.headlineLarge,),
            const SizedBox(height: AppSizes.spaceBtnSections),
            Text(
              TextStrings.signUpName,
              style: AppTextTheme.textStyles.bodyMedium,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _displayNameController,
              hintText: TextStrings.signUpNameHint,
            ),
            const SizedBox(height: AppSizes.spaceBtnInputFields),
            Text(
              TextStrings.signUpEmail,
              style: AppTextTheme.textStyles.bodyMedium,
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: _emailController,
              hintText: TextStrings.signUpEmailHint,
            ),
            const SizedBox(height: AppSizes.spaceBtnInputFields),
            Text(
              TextStrings.signUpPassword,
              style: AppTextTheme.textStyles.bodyMedium,
            ),
            SizedBox(height: 8),
            PasswordField(controller: _passwordController),
            const SizedBox(height: 8),
            Text(
              TextStrings.signUpCaseSensitive,
              style: AppTextTheme.textStyles.labelSmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: AppSizes.spaceBtnItems),
            _buildTermsCheckbox(),
            const SizedBox(height: AppSizes.spaceBtnSections),
            _buildSignUpButton(),
            const SizedBox(height: AppSizes.spaceBtnSections),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Already have an account? ",
                  style: AppTextTheme.textStyles.bodyMedium?.copyWith(color: AppColors.black),
                  children: [
                    TextSpan(
                      text: "Login!",
                      style: AppTextTheme.textStyles.labelMedium?.copyWith(color: AppColors.orange),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            _register();
          } else {
            // Show error
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.white, backgroundColor: AppColors.green, padding: EdgeInsets.symmetric(vertical: 16), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        child: Text("Sign Up"),
      ),
    );
  }
}

import 'package:dj_lunchbox/features/authentication/user_management/registration.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../bottom_navigation.dart';
import '../../../utils/constants/sizes.dart';
import './utils/BuildPasswordField.dart';
import './utils/BuildTextField.dart';
import 'forgotPassword.dart';

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
      final user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(userId: user.uid),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message; // Set the error message
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  TextStrings.login,
                  style: AppTextTheme.textStyles.headlineLarge),
              const SizedBox(height: AppSizes.spaceBtnSections),
              Text(
                  TextStrings.loginEmail,
                  style: AppTextTheme.textStyles.bodyMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _emailController,
                hintText: "example@gmail.com",
              ),
              const SizedBox(height: AppSizes.spaceBtnInputFields),
              Text(
                TextStrings.loginPassword,
                style: AppTextTheme.textStyles.bodyMedium
              ),
              const SizedBox(height: 8),
              PasswordField(
                  controller: _passwordController),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Case sensitive",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: Text(
                      TextStrings.loginForgotPassword,
                      style: AppTextTheme.textStyles.bodyMedium?.copyWith(color: AppColors.lightGreen)
                      ),
                    )
                  ]),
              SizedBox(height: 16),
              _buildErrorMessage(),
              SizedBox(height: 16),
              _buildLoginButton(),
              SizedBox(height: 16),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: AppTextTheme.textStyles.bodyMedium?.copyWith(color: AppColors.black),
                    children: [
                      TextSpan(
                        text: "Sign Up!",
                        style: AppTextTheme.textStyles.labelMedium?.copyWith(color: AppColors.orange),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
          ]
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
          foregroundColor: AppColors.white, backgroundColor: AppColors.green, padding: EdgeInsets.symmetric(vertical: 16), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        child: Text("Login"),
      ),
    );
  }
}

// lib/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile?.name ?? 'Gloria Chebet');
    _emailController = TextEditingController(text: widget.initialProfile?.email ?? 'gloriachebet@gmail.com');
    _weightController = TextEditingController(text: widget.initialProfile?.weight.toString() ?? '56 kg');
    _ageController = TextEditingController(text: widget.initialProfile?.age.toString() ?? '23 Years');
    _heightController = TextEditingController(text: widget.initialProfile?.height.toString() ?? '164 cm');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit your profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Update your profile here. Make it yours!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputField(
                  label: 'Name',
                  controller: _nameController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Email',
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Weight',
                  controller: _weightController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Age',
                  controller: _ageController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Height',
                  controller: _heightController,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: TextStyle(
            color: readOnly ? Colors.grey[600] : Colors.black,
          ),
        ),
      ],
    );
  }
}
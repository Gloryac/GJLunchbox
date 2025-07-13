// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../models/user_profile.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   final UserProfile initialProfile;
//   final Function(UserProfile) onSave;
//
//   const EditProfileScreen({
//     super.key,
//     required this.initialProfile,
//     required this.onSave,
//   });
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _weightController;
//   late TextEditingController _ageController;
//   late TextEditingController _heightController;
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.initialProfile.name);
//     _emailController = TextEditingController(text: widget.initialProfile.email);
//     _weightController =
//         TextEditingController(text: widget.initialProfile.weight.toString());
//     _ageController =
//         TextEditingController(text: widget.initialProfile.age.toString());
//     _heightController =
//         TextEditingController(text: widget.initialProfile.height.toString());
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       final updatedProfile = UserProfile(
//         name: _nameController.text,
//         email: _emailController.text,
//         weight: double.parse(_weightController.text),
//         age: int.parse(_ageController.text),
//         height: double.parse(_heightController.text),
//         imageUrl: _profileImage?.path ?? widget.initialProfile.imageUrl,
//       );
//
//       widget.onSave(updatedProfile);
//
//       if (mounted) {
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving profile: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveProfile,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Profile Picture
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundImage: _getProfileImage(),
//                         child: _profileImage == null &&
//                                 (widget.initialProfile.imageUrl == null ||
//                                     widget.initialProfile.imageUrl!.isEmpty)
//                             ? const Icon(Icons.camera_alt, size: 40)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Editable Fields
//                     _buildEditableField(
//                       label: 'Full Name',
//                       controller: _nameController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     _buildEditableField(
//                       label: 'Email',
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         if (!value.contains('@')) {
//                           return 'Please enter a valid email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     _buildEditableField(
//                       label: 'Weight (kg)',
//                       controller: _weightController,
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your weight';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Please enter a valid number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     _buildEditableField(
//                       label: 'Age',
//                       controller: _ageController,
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your age';
//                         }
//                         if (int.tryParse(value) == null) {
//                           return 'Please enter a valid number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//
//                     _buildEditableField(
//                       label: 'Height (cm)',
//                       controller: _heightController,
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your height';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Please enter a valid number';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
//
//   ImageProvider? _getProfileImage() {
//     if (_profileImage != null) {
//       return FileImage(_profileImage!);
//     }
//     if (widget.initialProfile.imageUrl != null &&
//         widget.initialProfile.imageUrl!.isNotEmpty) {
//       return NetworkImage(widget.initialProfile.imageUrl!);
//     }
//     return null;
//   }
//
//   Widget _buildEditableField({
//     required String label,
//     required TextEditingController controller,
//     required String? Function(String?)? validator,
//     TextInputType? keyboardType,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       validator: validator,
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _weightController.dispose();
//     _ageController.dispose();
//     _heightController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';

class EditProfileScreen extends StatefulWidget {
  final UserProfile initialProfile;
  final Function(UserProfile) onSave;

  const EditProfileScreen({
    super.key,
    required this.initialProfile,
    required this.onSave,
  });

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
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  Uint8List? _localImageBytes;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _emailController = TextEditingController(text: widget.initialProfile.email);
    _weightController =
        TextEditingController(text: widget.initialProfile.weight.toString());
    _ageController =
        TextEditingController(text: widget.initialProfile.age.toString());
    _heightController =
        TextEditingController(text: widget.initialProfile.height.toString());

    // Load local image if exists
    _loadLocalImage();
  }

  Future<void> _loadLocalImage() async {
    if (widget.initialProfile.imageUrl != null &&
        widget.initialProfile.imageUrl!.startsWith('local_')) {
      final userId = widget.initialProfile.imageUrl!.substring(6);
      final imageBytes = await _getLocalImage(userId);
      if (imageBytes != null) {
        setState(() {
          _localImageBytes = imageBytes;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Store image locally using SharedPreferences
  Future<String?> _saveImageLocally(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_${user.uid}', base64String);

      return 'local_${user.uid}'; // Return a local identifier
    } catch (e) {
      print('Error saving image locally: $e');
      return null;
    }
  }

  // Get locally stored image
  Future<Uint8List?> _getLocalImage(String imageId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64String = prefs.getString('profile_image_$imageId');
      if (base64String != null) {
        return base64Decode(base64String);
      }
      return null;
    } catch (e) {
      print('Error getting local image: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      String? imageUrl = widget.initialProfile.imageUrl;

      // Save new profile image locally if selected
      if (_profileImage != null) {
        imageUrl = await _saveImageLocally(_profileImage!);
      }

      final updatedProfile = UserProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        weight: double.parse(_weightController.text),
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        imageUrl: imageUrl,
      );

      // Save to Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': updatedProfile.name,
        'email': updatedProfile.email,
        'weight': updatedProfile.weight,
        'age': updatedProfile.age,
        'height': updatedProfile.height,
        'imageUrl': updatedProfile.imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Call the callback to update the parent widget
      widget.onSave(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const Text(
                  'Edit your profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Update your profile here. Make it yours!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Picture Section
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _getProfileImage(),
                          backgroundColor: Colors.grey[300],
                          child: _profileImage == null &&
                              (widget.initialProfile.imageUrl == null ||
                                  widget.initialProfile.imageUrl!.isEmpty)
                              ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Form Fields
                _buildFormField(
                  label: 'Name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _buildFormField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _buildFormField(
                  label: 'Weight',
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  suffix: 'kg',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Please enter a valid weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _buildFormField(
                  label: 'Age',
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  suffix: 'Years',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 120) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _buildFormField(
                  label: 'Height',
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  suffix: 'cm',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) {
                      return 'Please enter a valid height';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }
    if (_localImageBytes != null) {
      return MemoryImage(_localImageBytes!);
    }
    if (widget.initialProfile.imageUrl != null &&
        widget.initialProfile.imageUrl!.isNotEmpty &&
        !widget.initialProfile.imageUrl!.startsWith('local_')) {
      return NetworkImage(widget.initialProfile.imageUrl!);
    }
    return null;
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
}
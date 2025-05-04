import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dj_lunchbox/features/account/screens/tracking_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dj_lunchbox/features/authentication/user_management/login.dart';
import 'package:dj_lunchbox/features/account/models/user_profile.dart'; // Make sure this exists
import 'edit_profile_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> getUserStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) => snapshot.data() ?? {});
    }
    return Stream.value({});
  }

  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  String _calculateDobFromAge(int age) {
    final now = DateTime.now();
    final dob = DateTime(now.year - age, now.month, now.day);
    return dob.toIso8601String();
  }

  String formatValue(dynamic value) {
    if (value == null) return 'Unknown';
    if (value is double) return value.toStringAsFixed(1);
    if (value is int) return value.toString();
    return value.toString();
  }

  Widget _buildProfileInfo() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data ?? {};
        final name = userData['displayName']?.toString() ?? 'Unknown';
        final weightValue = formatValue(userData['weight']);
        final weightDisplay =
            weightValue != 'Unknown' ? '$weightValue kg' : 'Unknown';
        final heightValue = formatValue(userData['height']);
        final heightDisplay =
            heightValue != 'Unknown' ? '$heightValue cm' : 'Unknown';
        final dob = userData['dob'] != null
            ? DateTime.parse(userData['dob'].toString())
            : null;
        final age = dob != null ? calculateAge(dob).toString() : 'Unknown';

        return Column(
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Weight', weightDisplay),
                _buildMetricCard('Age', '$age years'),
                _buildMetricCard('Height', heightDisplay),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : const NetworkImage(
                                'https://via.placeholder.com/150'),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                size: 18, color: Colors.white),
                            onPressed: _showImageSourceDialog,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 18, color: Colors.white),
                            onPressed: () => _pickImage(ImageSource.camera),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildProfileInfo(),
                const SizedBox(height: 24),
                _buildMenuButton(
                  context,
                  'Manage Account',
                  Icons.person_outline,
                  () async {
                    final user = _auth.currentUser;
                    if (user != null) {
                      try {
                        final doc = await _firestore
                            .collection('users')
                            .doc(user.uid)
                            .get();
                        if (doc.exists) {
                          final userData = doc.data()!;
                          final currentProfile = UserProfile(
                            name: userData['displayName']?.toString() ??
                                'Unknown',
                            email: user.email ?? 'No email',
                            weight:
                                (userData['weight'] as num?)?.toDouble() ?? 0.0,
                            height:
                                (userData['height'] as num?)?.toDouble() ?? 0.0,
                            age: userData['dob'] != null
                                ? calculateAge(
                                    DateTime.parse(userData['dob'].toString()))
                                : 0,
                            imageUrl: userData['photoURL']?.toString(),
                          );

                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                initialProfile: currentProfile,
                                onSave: (updatedProfile) async {
                                  try {
                                    await _firestore
                                        .collection('users')
                                        .doc(user.uid)
                                        .update({
                                      'displayName': updatedProfile.name,
                                      'weight': updatedProfile.weight,
                                      'height': updatedProfile.height,
                                      'dob': _calculateDobFromAge(
                                          updatedProfile.age),
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Profile updated successfully')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error updating profile: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error loading profile: $e')),
                          );
                        }
                      }
                    }
                  },
                ),
                _buildMenuButton(
                  context,
                  'Tracking',
                  Icons.show_chart,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackingScreen()),
                  ),
                ),
                _buildMenuButton(
                  context,
                  'Linked Accounts',
                  Icons.link,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrackingScreen()),
                  ),
                ),
                _buildMenuButton(
                  context,
                  'Help',
                  Icons.help_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrackingScreen()),
                  ),
                ),
                _buildMenuButton(
                  context,
                  'Logout',
                  Icons.logout,
                  () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true) {
                      await _auth.signOut();
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

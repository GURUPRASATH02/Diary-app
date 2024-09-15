import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _securityPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Method to load the stored username and security pin
  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _securityPinController.text = prefs.getString('security_pin') ?? '';
    });
  }

  // Method to save the updated username and security pin
  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('security_pin', _securityPinController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    Navigator.of(context).pop(); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _securityPinController,
              decoration: const InputDecoration(
                labelText: 'Security Pin',
              ),
              keyboardType: TextInputType.number,
              obscureText: true, // Hide the security pin input
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

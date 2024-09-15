
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      //home: const SplashScreen(),
      home: HomeScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isRegistered = prefs.getBool('isRegistered') ?? false;

      if (isRegistered) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const PinScreen(),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const RegistrationForm(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Image(image: AssetImage('img/diary.jpg')),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Happy to see you',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('securityPin', _pinController.text);
      await prefs.setBool('isRegistered', true);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'Security Pin'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a security pin';
                  } else if (value.length < 4) {
                    return 'Pin must be at least 4 digits long';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPinController,
                decoration: const InputDecoration(labelText: 'Confirm Pin'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your pin';
                  } else if (value != _pinController.text) {
                    return 'Pins do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();

  Future<void> _checkPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPin = prefs.getString('securityPin');

    if (_pinController.text == savedPin) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect Pin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Pin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _pinController,
              decoration:
                  const InputDecoration(labelText: 'Enter Security Pin'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkPin,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

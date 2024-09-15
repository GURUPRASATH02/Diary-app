import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutDeveloper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About the Developer'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('img/user.jpg'), // Replace with your photo
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Guruprasath',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // Apply color here
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'About Me:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'I am a passionate developer with expertise in creating mobile applications. My goal is to build intuitive and user-friendly apps that make everyday tasks easier. With a background in software development and a keen interest in new technologies, I strive to deliver high-quality solutions tailored to users’ needs.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Skills and Expertise:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '- Mobile App Development\n'
                '- UI/UX Design\n'
                '- Flutter & Dart\n'
                '- Android & iOS Development\n'
                '- Backend Integration\n'
                '- Problem Solving and Optimization',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Me:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Email: guruprasath2902@gmail.com\n'
                'LinkedIn: https://www.linkedin.com/in/guru-prasath-0a34bb268/\n'
                'GitHub: https://github.com/GURUPRASATH02',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Thank you for using the Diary Day\'s app!',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

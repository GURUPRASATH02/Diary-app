import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Diary Day\'s'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center( // Center the title after the AppBar
                child: Text(
                  'Diary Day\'s - Your Personal Diary Writing App',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Diary Day\'s is a simple and intuitive diary writing mobile application that helps you capture and organize your thoughts, daily moments, and plans effortlessly.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Justify the text
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '- Write and save your daily thoughts, memories, and reflections.\n'
                '- Organize your tasks with a Todo feature.\n'
                '- Track daily moments and special events.\n'
                '- Store your diary entries securely.\n'
                '- Easy navigation and user-friendly interface.\n'
                '- Create categories to classify and organize diary entries.\n'
                '- Add favorite or important entries for quick access.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Justify the text
              ),
              SizedBox(height: 16),
              Text(
                'Our Mission:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Diary Day\'s aims to be a perfect companion for your journaling journey, allowing you to write down your thoughts, reflect on past experiences, and plan future tasks, all in one app. Whether it’s personal journaling or organizing your daily life, Diary Day\'s is here to help.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Justify the text
              ),
              SizedBox(height: 16),
              Text(
                'Privacy & Security:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We respect your privacy. All your diary entries and personal information are stored securely on your device, ensuring that your data is safe and private.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Justify the text
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions, feedback, or suggestions, feel free to reach out to us at support@diarydays.com. We’d love to hear from you!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Justify the text
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Version 1.0.0',
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

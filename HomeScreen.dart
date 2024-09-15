import 'package:diary_app/AboutAppPage.dart';
import 'package:diary_app/AboutDeveloper.dart';
import 'package:diary_app/AddTodoPage.dart';
import 'package:diary_app/EditProfilePage.dart';
import 'package:diary_app/ListMomentsPage.dart';
import 'package:diary_app/ListTodoPage.dart';
import 'package:diary_app/TodayHappensPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = ''; // Variable to hold username
  Color _backgroundColor = Color.fromARGB(255, 182, 109, 124); // Default background color

  int _selectedIndex = 0; // Current index for BottomNavigationBar

  @override
  void initState() {
    super.initState();
    loadUsername(); // Load the username from shared preferences
  }

  // Load the username from shared preferences
  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Guest'; // Default to 'Guest' if no username is found
    });
  }

  // Handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Logic to navigate based on selected index
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListTodoPage(),
      ));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TodayHappensPage(),
      ));
    } else if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListMomentsPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Use dynamic background color
      appBar: AppBar(
        title: const Text(
          "Diary's Day",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Remove shadow
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, // Align to the left side
                      child: CircleAvatar(
                        backgroundImage: AssetImage('img/user.jpg'), // Replace with your image
                        radius: 30, // Set the size of the circular avatar
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Add spacing between the image and username
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight, // Align username to the right
                      child: Text(
                        _username, // Display the username
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Username & Security Pin'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AboutAppPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('About Developer'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AboutDeveloper(),
                ));
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            // Change background color before navigating
            setState(() {
              _backgroundColor = Colors.greenAccent; // Change color
            });

            // Navigate to AddTodoPage
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTodoPage(),
            )).then((_) {
              // Reset background color after returning from AddTodoPage
              setState(() {
                _backgroundColor = Color.fromARGB(255, 182, 109, 124); // Reset to original color
              });
            });
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todo List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Moments',
          ),
        ],
        currentIndex: _selectedIndex, // Use state to manage selected index
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped, // Handle item taps
      ),
    );
  }
}

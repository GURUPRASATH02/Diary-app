// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ListMomentsPage extends StatefulWidget {
  @override
  _ListMomentsPageState createState() => _ListMomentsPageState();
}

class _ListMomentsPageState extends State<ListMomentsPage> {
  List<Map<String, dynamic>> momentsList = [];
  Set<String> likedMoments = Set<String>();
   //Color _backgroundColor = Color.fromARGB(255, 182, 109, 124);
  @override
  void initState() {
    super.initState();
    _loadAllMoments();
  }

  Future<void> _loadAllMoments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<Map<String, dynamic>> loadedMoments = [];

    for (var key in keys) {
      if (key.startsWith('content_')) {
        String date = key.substring(8); // Extract the date from the key
        String content = prefs.getString(key) ?? '';
        String? imagePath = prefs.getString('image_$date');

        loadedMoments.add({
          'date': date,
          'content': content,
          'imagePath': imagePath ?? '',
        });
      }
    }

    setState(() {
      momentsList = loadedMoments;
    });
  }

  Future<void> _editMoment(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentContent = prefs.getString('content_$date') ?? '';
    String? currentImagePath = prefs.getString('image_$date');

    TextEditingController contentController =
        TextEditingController(text: currentContent);
    
    XFile? pickedFile;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Moment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    currentImagePath = pickedFile?.path;
                  });
                },
                child: Text('Pick Image'),
              ),
              if (currentImagePath != null)
                Image.file(
                  File(currentImagePath!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String updatedContent = contentController.text;

                // Update SharedPreferences
                await prefs.setString('content_$date', updatedContent);
                if (pickedFile != null) {
                  await prefs.setString('image_$date', pickedFile!.path);
                }

                _loadAllMoments(); // Reload the moments after editing
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _likeMoment(String date) {
    setState(() {
      if (likedMoments.contains(date)) {
        likedMoments.remove(date);
      } else {
        likedMoments.add(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Moments"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        //color: Color.fromARGB(255, 182, 109, 124), // Set the background color
        child: momentsList.isNotEmpty
            ? ListView.builder(
                itemCount: momentsList.length,
                itemBuilder: (context, index) {
                  String date = momentsList[index]['date']!;
                  String content = momentsList[index]['content']!;
                  String? imagePath = momentsList[index]['imagePath'];

                  return Card(
                    color: Colors.grey[850], // Dark card color
                    elevation: 4,
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        "Date: $date",
                        style: TextStyle(color: Colors.white), // Light text color
                      ),
                      subtitle: Text(
                        content,
                        style: TextStyle(color: Colors.grey[300]), // Light text color for subtitle
                      ),
                      leading: imagePath!.isNotEmpty
                          ? Image.file(
                              File(imagePath),
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image_not_supported,
                              color: Colors.white, // Icon color
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              _editMoment(date);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              likedMoments.contains(date)
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined,
                              color: likedMoments.contains(date)
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _likeMoment(date);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "No moments saved yet.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
      ),
    );
  }
}

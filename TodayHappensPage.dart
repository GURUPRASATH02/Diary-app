// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class TodayHappensPage extends StatefulWidget {
  TodayHappensPage({super.key});

  @override
  _TodayHappensPageState createState() => _TodayHappensPageState();
   Color _backgroundColor = Color.fromARGB(255, 182, 109, 124);
}

class _TodayHappensPageState extends State<TodayHappensPage>
  
    with SingleTickerProviderStateMixin {
  TextEditingController contentController = TextEditingController();
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _loadData();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(_animationController);
    _animationController.forward();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    contentController.text = prefs.getString('content_$currentDate') ?? '';
    String? imagePath = prefs.getString('image_$currentDate');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('content_$currentDate', contentController.text);
    if (_image != null) {
      await prefs.setString('image_$currentDate', _image!.path);
    }
  }

  Future<void> _requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var storageStatus = await Permission.storage.request();
    if (cameraStatus.isDenied || storageStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera or Storage permission denied!")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      await _requestPermissions(); // Ensure permissions are granted
      if (await Permission.storage.isGranted) {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No image selected")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Storage permission is not granted!")),
        );
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image from gallery")),
      );
    }
  }

  Future<void> _takePicture() async {
    try {
      await _requestPermissions(); // Ensure permissions are granted
      if (await Permission.camera.isGranted) {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No picture taken")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Camera permission is not granted!")),
        );
      }
    } catch (e) {
      print("Error taking picture: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to take picture")),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Happenings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Date: $currentDate",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SlideTransition(
                position: _animation,
                child: Center(
                  child: Card(
                    key: ValueKey<int>(currentDate.hashCode),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What happened today?",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextField(
                            controller: contentController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Enter details of your day",
                            ),
                          ),
                          SizedBox(height: 16),
                          _image != null
                              ? Image.file(_image!, height: 100, width: 100)
                              : Text("No image selected"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.photo),
                                onPressed: _pickImageFromGallery,
                                tooltip: "Upload from gallery",
                              ),
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: _takePicture,
                                tooltip: "Take a picture",
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()) == currentDate) {
                                  _saveData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Data saved for today!"),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "You can only enter data for today."),
                                    ),
                                  );
                                }
                              },
                              child: Text("Save Today's Happenings"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

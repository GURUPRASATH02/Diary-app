// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // for encoding/decoding JSON

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TimeOfDay _selectedTime = TimeOfDay.now();
   var _backgroundColor = const Color.fromARGB(255, 182, 109, 124);
  // Method to save a todo in shared preferences
  Future<void> _saveTodo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Retrieve existing todos list (if any)
    List<String> existingTodos = prefs.getStringList('todos') ?? [];

    // Create new todo as a map
    Map<String, String> newTodo = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': _selectedDate,
      'time': _selectedTime.format(context),
    };

    // Add the new todo to the list
    existingTodos.add(jsonEncode(newTodo));

    // Save the updated list of todos back to shared preferences
    await prefs.setStringList('todos', existingTodos);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todo successfully stored!')),
    );

    // Navigate back or reset inputs after saving
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final DateTime initialDate = DateTime.parse(_selectedDate);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        backgroundColor: Colors.white,
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Date: $_selectedDate'),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Choose Date'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Time: ${_selectedTime.format(context)}'),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickTime,
                      child: const Text('Choose Time'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveTodo,
                  child: const Text('Save Todo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('_backgroundColor', _backgroundColor));
  }
}

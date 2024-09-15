// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // for encoding/decoding JSON

class ListTodoPage extends StatefulWidget {
  const ListTodoPage({super.key});

  @override
  _ListTodoPageState createState() => _ListTodoPageState();
}

class _ListTodoPageState extends State<ListTodoPage> {
  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> _filteredTodos = [];
  String _filterOption = 'all'; // Default filter option
   Color _backgroundColor = const Color.fromARGB(255, 182, 109, 124);
  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // Method to load todos from shared preferences
  Future<void> _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the list of todos (if any)
    List<String> storedTodos = prefs.getStringList('todos') ?? [];

    // Decode each todo from JSON and add to the list
    List<Map<String, dynamic>> todos = storedTodos.map((todo) {
      return Map<String, dynamic>.from(jsonDecode(todo));
    }).toList();

    setState(() {
      _todos = todos;
      _filteredTodos = todos; // Initially, no filtering
    });
  }

  // Method to remove a todo
  Future<void> _removeTodo(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _todos.removeAt(index);
      _filteredTodos.removeAt(index);
    });

    // Save updated todos back to SharedPreferences
    List<String> updatedTodos = _todos.map((todo) => jsonEncode(todo)).toList();
    await prefs.setStringList('todos', updatedTodos);
  }

  // Toggle 'liked' status
  void _toggleLike(int index) {
    setState(() {
      _todos[index]['liked'] = !(_todos[index]['liked'] ?? false);
      _applyFilter(_filterOption); // Reapply filter after toggle
    });
  }

  // Toggle 'marked as later' status
  void _toggleMarkAsLater(int index) {
    setState(() {
      _todos[index]['markedLater'] = !(_todos[index]['markedLater'] ?? false);
      _applyFilter(_filterOption); // Reapply filter after toggle
    });
  }

  // Method to edit a todo
  Future<void> _editTodo(
      int index, String newTitle, String newDescription, String newDate, String newTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _todos[index]['title'] = newTitle;
      _todos[index]['description'] = newDescription;
      _todos[index]['date'] = newDate;
      _todos[index]['time'] = newTime;
    });

    // Save updated todos back to SharedPreferences
    List<String> updatedTodos = _todos.map((todo) => jsonEncode(todo)).toList();
    await prefs.setStringList('todos', updatedTodos);
  }

  // Method to apply filter based on user's choice
  void _applyFilter(String filterOption) {
    setState(() {
      _filterOption = filterOption;
      if (filterOption == 'liked') {
        _filteredTodos = _todos.where((todo) => todo['liked'] == true).toList();
      } else if (filterOption == 'markedLater') {
        _filteredTodos = _todos.where((todo) => todo['markedLater'] == true).toList();
      } else {
        _filteredTodos = _todos; // No filter, show all
      }
    });
  }

  // Method to show a dialog for editing todo
  Future<void> _showEditDialog(int index) async {
    final todo = _todos[index];
    TextEditingController titleController =
        TextEditingController(text: todo['title']);
    TextEditingController descriptionController =
        TextEditingController(text: todo['description']);
    TextEditingController dateController = TextEditingController(text: todo['date']);
    TextEditingController timeController = TextEditingController(text: todo['time']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editTodo(
                    index,
                    titleController.text,
                    descriptionController.text,
                    dateController.text,
                    timeController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              _applyFilter(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'all',
                child: Text('All Todos'),
              ),
              const PopupMenuItem<String>(
                value: 'liked',
                child: Text('Liked Todos'),
              ),
              const PopupMenuItem<String>(
                value: 'markedLater',
                child: Text('Marked as Later'),
              ),
            ],
          ),
        ],
      ),
      body: _filteredTodos.isEmpty
          ? const Center(child: Text('No Todos Available'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = _filteredTodos[index];
                final isLiked = todo['liked'] ?? false;
                final isMarkedLater = todo['markedLater'] ?? false;

                return Card(
                  color: isMarkedLater ? Colors.orange.shade100 : null,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Consistent padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todo['description'] ?? 'No Description',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${todo['date']} at ${todo['time']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Like Button
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_outline_sharp,
                                color: isLiked ? Colors.green : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(index),
                            ),
                            // Mark as Later Button
                            IconButton(
                              icon: Icon(
                                Icons.watch_later_outlined,
                                color: isMarkedLater
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                              onPressed: () => _toggleMarkAsLater(index),
                            ),
                            // Mark as Done Button
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              color: Colors.red,
                              onPressed: () => _removeTodo(index),
                            ),
                            // Edit Button
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditDialog(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

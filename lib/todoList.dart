import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Map<String, dynamic>> todos = [];
  TextEditingController inputController = TextEditingController();
  TextEditingController editController = TextEditingController();
  int? editIndex;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  // Load todos from local storage
  Future<void> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTodos = prefs.getString('todos');
    print('Loaded todos: $storedTodos'); // 调试信息
    if (storedTodos != null) {
      setState(() {
        todos = List<Map<String, dynamic>>.from(json.decode(storedTodos));
      });
    }
  }

  // Save todos to local storage
  Future<void> saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedTodos = json.encode(todos);
    print('Saved todos: $encodedTodos');
    prefs.setString('todos', encodedTodos);
  }

  // Add a new todo
  void addTodo() {
    if (inputController.text.trim().isNotEmpty) {
      setState(() {
        todos.add({'text': inputController.text.trim(), 'completed': false});
        inputController.clear();
      });
      saveTodos(); // Save todos after adding
    }
  }

  // Toggle the completed status of a todo
  void toggleTodoStatus(int index) {
    setState(() {
      todos[index]['completed'] = !todos[index]['completed'];
    });
    saveTodos(); // Save todos after toggling
  }

  // Set the todo to be edited
  void editTodo(int index) {
    setState(() {
      editIndex = index;
      editController.text = todos[index]['text'];
    });
  }

  // Confirm the edit of a todo
  void confirmEditTodo() {
    if (editController.text.trim().isNotEmpty) {
      setState(() {
        todos[editIndex!]['text'] = editController.text.trim();
        editIndex = null;
        editController.clear();
      });
      saveTodos(); // Save todos after editing
    }
  }

  // Delete a todo
  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    saveTodos(); // Save todos after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.blueGrey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      hintText: 'Add a new task',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: todos[index]['completed'],
                      onChanged: (value) {
                        toggleTodoStatus(index);
                      },
                    ),
                    title: editIndex == index
                        ? TextField(
                            controller: editController,
                            decoration: InputDecoration(
                              hintText: 'Edit task',
                            ),
                            onSubmitted: (_) => confirmEditTodo(),
                          )
                        : GestureDetector(
                            onTap: () => toggleTodoStatus(index),
                            child: Text(
                              todos[index]['text'],
                              style: TextStyle(
                                decoration: todos[index]['completed']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        editIndex == index
                            ? IconButton(
                                icon: Icon(Icons.check),
                                color: Colors.green,
                                onPressed: confirmEditTodo,
                              )
                            : IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () => editTodo(index),
                              ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => deleteTodo(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

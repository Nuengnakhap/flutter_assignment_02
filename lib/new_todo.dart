import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/method.dart';

class NewTodo extends StatefulWidget {
  _NewTodoState createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final _key = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: title,
                decoration: InputDecoration(labelText: "Subject"),
                validator: (value) {
                  if (value.isEmpty) return "Please fill subject";
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () async {
                        if (_key.currentState.validate()) {
                          await TodoProvider.db.insertTodo(
                            Todo(title: title.text, done: false),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

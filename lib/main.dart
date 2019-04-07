import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/method.dart';
import 'new_todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // DBProvider.db.deleteAll();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _index == 0 ? Icons.add : Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              _index == 0
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewTodo()))
                  : await TodoProvider.db.deleteDone();
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: _index == 0
            ? TodoProvider.db.getUnDoneTodo()
            : TodoProvider.db.getDoneTodo(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Todo item = snapshot.data[index];
                return Container(
                  transform: Matrix4.translationValues(0, -0.5, 0),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(width: 0.5)),
                  ),
                  child: ListTile(
                    title: Text(item.title),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        TodoProvider.db.doneOrUndone(item);
                        setState(() {});
                      },
                      value: item.done,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No data found..'),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Task")),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed")),
        ],
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}

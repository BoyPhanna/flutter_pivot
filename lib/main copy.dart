import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DragAndDropExample(),
    );
  }
}

class DragAndDropExample extends StatefulWidget {
  @override
  _DragAndDropExampleState createState() => _DragAndDropExampleState();
}

class _DragAndDropExampleState extends State<DragAndDropExample> {
  String say = "Say";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drag and Drop Example')),
      body: Column(
        children: [
          DragTarget<String>(onAcceptWithDetails: (details) {
            setState(() {
              say = details.data;
            });
          }, builder: (context, candidateData, rejectedData) {
            return Draggable<String>(
              data: "Hello",
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Center(child: Text('Drag me')),
              ),
              feedback: Material(
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue.withOpacity(0.5),
                  child: Center(child: Text('Dragging')),
                ),
              ),
              childWhenDragging: Container(
                width: 100,
                height: 100,
                color: Colors.grey,
                child: Center(child: Text('Original')),
              ),
            );
          }),
          SizedBox(height: 50),
          DragTarget<String>(
            onAcceptWithDetails: (details) {
              setState(() {
                say = details.data;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<String>(
                data: "say",
                feedback: Material(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.blue,
                    child: Center(child: Text('${say}')),
                  ),
                ),
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                  child: Center(child: Text('${say}')),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

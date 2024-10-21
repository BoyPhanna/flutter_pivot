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
  List<String> upper = [];
  List<String> upper_rigth = [];
  List<String> lower = ["A", "B", "C", "D"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drag and Drop Example')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    setState(() {
                      print("${details.data}");
                      clearItem(details.data);

                      upper.add(details.data);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 400,
                      height: 400,
                      color: Colors.yellow,
                      child: SingleChildScrollView(
                        child: Column(
                          children: containers(upper),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    setState(() {
                      print("${details.data}");
                      clearItem(details.data);

                      upper_rigth.add(details.data);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 400,
                      height: 400,
                      color: Colors.yellow,
                      child: SingleChildScrollView(
                        child: Column(
                          children: containers(upper_rigth),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 50),
            DragTarget<String>(
              onAcceptWithDetails: (details) {
                setState(() {
                  clearItem(details.data);
                  lower.add(details.data);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 400,
                  height: 400,
                  color: Colors.red,
                  child: SingleChildScrollView(
                    child: Column(
                      children: containers(lower),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> containers(List<String> type) {
    return type.map((e) {
      return Draggable(
        data: e,
        feedback: Material(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue,
            width: 100,
            height: 100,
            child: Text(e),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 100,
          height: 100,
          child: Text(e),
        ),
      );
    }).toList();
  }

  void clearItem(String item) {
    lower.removeWhere((t) => t == item);
    upper.removeWhere((t) => t == item);
    upper_rigth.removeWhere((t) => t == item);
  }
}

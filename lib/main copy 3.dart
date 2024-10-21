import 'package:flutter/material.dart';
import 'package:pivot/table.dart';

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
  List<String> columns = [];
  List<String> fields = ["ID", "Name", "Designation", "Salary"];
  List<String> rows = [];
  Set<String> name = Set();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lab Privot')),
      body: Column(
        children: [
          PanelTaget(
            label: "All Columns",
            width: double.infinity,
            hieght: 60,
            onAccept: (p0) {
              setState(() {
                clearItem(p0);
                fields.add(p0);
              });
            },
            child: Row(
              children: [
                SizedBox(
                  width: 115,
                ),
                ...containers(fields)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          PanelTaget(
            label: "Columns Group",
            width: double.infinity,
            hieght: 60,
            onAccept: (p0) {
              setState(() {
                clearItem(p0);
                columns.add(p0);
              });
            },
            child: Row(
              children: [
                SizedBox(
                  width: 115,
                ),
                ...containers(columns)
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  PanelTaget(
                    setLabelToVertical: true,
                    label: "Rows Group",
                    child: Column(
                      children: [
                        ...containers(rows),
                      ],
                    ),
                    onAccept: (t) {
                      setState(() {
                        clearItem(t);
                        rows.add(t);
                      });
                    },
                    hieght: double.infinity,
                    width: 105,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: DataGridExample(
                        groups: rows,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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
            color: Theme.of(context).primaryColor,
            width: 100,
            height: 50,
            child: Text(e),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          margin: EdgeInsets.all(3),
          width: 100,
          height: 50,
          child: Text(e),
        ),
      );
    }).toList();
  }

  void clearItem(String item) {
    rows.removeWhere((t) => t == item);
    columns.removeWhere((t) => t == item);
    fields.removeWhere((t) => t == item);
  }
}

class PanelTaget extends StatelessWidget {
  final Widget child;
  final Function(String) onAccept;
  final double width;
  final double hieght;
  final String label;
  final bool setLabelToVertical;
  const PanelTaget({
    super.key,
    required this.child,
    required this.onAccept,
    required this.hieght,
    required this.width,
    this.label = "",
    this.setLabelToVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        onAccept(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: width,
          height: hieght,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              RotatedBox(
                quarterTurns: setLabelToVertical ? -1 : 0,
                child: Text("${label}"),
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}

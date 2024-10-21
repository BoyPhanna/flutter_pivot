import 'package:flutter/material.dart';
import 'package:pivot/group_table.dart';
import 'package:pivot/pivot_table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Pivot Table')),
        body:
            // GroupedPaginatedTable(),

            HomePage(
          orhers: ["sales", "profit", "quantity", "rating", "discount"],
          valueKey: "cost",
          rowKey: "category",
          columnKey: "region",
          selectedFilterKey: "year",
          json: '''
[
  {
    "category": "Fruits",
    "region": "North",
    "year": 2023,
    "cost": 7000,
    "sales": 1200,
    "profit": 300,
    "quantity": 500,
    "supplier": "Supplier A",
    "discount": 5,
    "rating": 4.5,
    "availability": "In Stock"
  },
  {
    "category": "Fruits",
    "region": "South",
    "year": 2023,
    "cost": 7000,
    "sales": 1500,
    "profit": 400,
    "quantity": 550,
    "supplier": "Supplier B",
    "discount": 7,
    "rating": 4.7,
    "availability": "In Stock"
  },
  {
    "category": "Vegetables",
    "region": "North",
    "year": 2022,
    "cost": 7000,
    "sales": 1100,
    "profit": 250,
    "quantity": 600,
    "supplier": "Supplier C",
    "discount": 6,
    "rating": 4.3,
    "availability": "Out of Stock"
  },
  {
    "category": "Vegetables",
    "region": "GTA",
    "year": 2023,
    "cost": 7000,
    "sales": 900,
    "profit": 200,
    "quantity": 450,
    "supplier": "Supplier D",
    "discount": 4,
    "rating": 4.0,
    "availability": "In Stock"
  },
  {
    "category": "Fruits",
    "region": "GTA",
    "year": 2022,
    "cost": 7000,
    "sales": 1000,
    "profit": 220,
    "quantity": 480,
    "supplier": "Supplier E",
    "discount": 5,
    "rating": 4.1,
    "availability": "In Stock"
  },
  {
    "category": "Vegetables",
    "region": "South",
    "year": 2023,
    "cost": 7000,
    "sales": 900,
    "profit": 210,
    "quantity": 420,
    "supplier": "Supplier F",
    "discount": 6,
    "rating": 4.4,
    "availability": "Out of Stock"
  },
  {
    "category": "Vegetables",
    "region": "KSK",
    "year": 2022,
    "cost": 7000,
    "sales": 1000,
    "profit": 300,
    "quantity": 500,
    "supplier": "Supplier G",
    "discount": 8,
    "rating": 4.6,
    "availability": "In Stock"
  },
  {
    "category": "Vegetables",
    "region": "TK",
    "year": 2021,
    "cost": 9000,
    "sales": 1000,
    "profit": 350,
    "quantity": 540,
    "supplier": "Supplier H",
    "discount": 10,
    "rating": 4.8,
    "availability": "In Stock"
  }
]
''',
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String columnKey;
  final String rowKey;
  final String valueKey;
  final String selectedFilterKey;
  final String json;
  final List<String> orhers;
  const HomePage({
    super.key,
    required this.columnKey,
    required this.rowKey,
    required this.valueKey,
    required this.selectedFilterKey,
    required this.json,
    required this.orhers,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> orhers = ["sales"];
  List<String> columns = [
    "product",
  ];
  List<String> filters = [
    'year',
  ];
  List<String> rows = [
    "location",
  ];
  List<String> values = [
    "price",
  ];

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
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            margin: EdgeInsets.all(3),
            width: double.infinity,
            height: 50,
            child: Text(e),
          ),
        ),
        // Offset to center the feedback under the pointer

        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          margin: EdgeInsets.all(3),
          width: double.infinity,
          height: 50,
          child: Text(e),
        ),
      );
    }).toList();
  }

  void clearItem(String item, String switchItem) {
    print("Item : $item , SwitchItem : $switchItem");
    if (rows.contains(item)) {
      rows.removeWhere((t) => t == item);
      rows.add(switchItem);
    } else if (columns.contains(item)) {
      columns.removeWhere((t) => t == item);
      columns.add(switchItem);
    } else if (filters.contains(item)) {
      filters.removeWhere((t) => t == item);
      filters.add(switchItem);
    } else if (values.contains(item)) {
      values.removeWhere((t) => t == item);
      values.add(switchItem);
    } else if (orhers.contains(item)) {
      orhers.removeWhere((t) => t == item);
      orhers.add(switchItem);
    }
  }

  @override
  void initState() {
    columns[0] = widget.columnKey;
    rows[0] = widget.rowKey;
    filters[0] = widget.selectedFilterKey;
    values[0] = widget.valueKey;
    orhers = widget.orhers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String json = widget.json;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PivotTable(
          json: json,
          key: ValueKey(
              '${columns[0]}}_${rows[0]}}_${values[0]}_${filters[0]}_${orhers[0]}'),
          columnKey: columns[0],
          rowKey: rows[0],
          selectedFilterKey: filters[0],
          valueKey: values[0],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            PanelTaget(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...containers(orhers),
                    ],
                  ),
                ),
                onAccept: (e) {
                  setState(() {
                    if (!orhers.contains(e)) {
                      clearItem(e, orhers[0]);
                      orhers.add(e);
                      orhers.removeAt(0);
                    }
                  });
                },
                hieght: 200,
                width: 400),
            Container(
              width: 400,
              height: 400,
              color: Colors.green,
              child: GridView.count(
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 2,
                children: [...allPanel()],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> allPanel() {
    return [
      panel(filters, 'Filter'),
      panel(columns, 'columns'),
      panel(rows, 'rows'),
      panel(values, 'values'),
    ];
  }

  Widget panel(
    List<String> type,
    String label,
  ) {
    return PanelTaget(
        child: Draggable(
          child: Column(
            children: [
              Text(label),
              Container(
                alignment: Alignment.center,
                color: Theme.of(context).primaryColor,
                width: 100,
                height: 50,
                child: Text(
                  type[0],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ],
          ),
          data: type[0],
          feedback: Material(
            child: Container(
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              width: 100,
              height: 50,
              child: Text(type[0]),
            ),
          ),
        ),
        onAccept: (e) {
          setState(() {
            clearItem(e, type[0]);
            type.add(e);
            type.removeAt(0);
          });
        },
        hieght: 100,
        width: 100);
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

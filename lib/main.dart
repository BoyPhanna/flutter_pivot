import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Pivot Table')),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> columns = [];
  List<String> fields = ["ID", "Name", "Designation", "Salary"];
  List<String> rows = [];

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PivotTable(),
        Container(
          width: 400,
          height: 400,
          color: Colors.green,
          child: GridView.count(
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            crossAxisCount: 2,
            children: [
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PivotTable extends StatefulWidget {
  @override
  _PivotTableState createState() => _PivotTableState();
}

class _PivotTableState extends State<PivotTable> {
  List<Map<String, dynamic>> jsonData = [];
  List<String> rowHeaders = [];
  List<String> columnHeaders = [];
  List<String> filterValues = [];
  String selectedFilterValue = '';
  String selectedFilterKey = 'year'; // Default filter

  List<String> filterKeys = [
    'year',
    'category',
    'region',
    "cost",
  ]; // Fields to filter by

  String rowKey = 'category';
  String columnKey = 'sales';
  String valueKey = 'region'; // Changeable depending on the data

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Sample JSON Data
    String jsonString = '''
    [
      {"category": "Fruits", "region": "North", "year": 2023,"cost":7000, "sales": 1200},
      {"category": "Fruits", "region": "South", "year": 2023,"cost":7000, "sales": 1500},
      {"category": "Vegetables", "region": "North", "year": 2022,"cost":7000, "sales": 1100},
      {"category": "Vegetables", "region": "GTA", "year": 2023,"cost":7000, "sales": 900},
      {"category": "Fruits", "region": "GTA", "year": 2022,"cost":7000, "sales": "High"},
      {"category": "Vegetables", "region": "South", "year": 2023,"cost":7000, "sales": 900},
      {"category": "Vegetables", "region": "KSK", "year": 2022,"cost":7000, "sales": "Medium"}
    ]
    ''';

    final List<dynamic> jsonList = json.decode(jsonString);
    jsonData = List<Map<String, dynamic>>.from(jsonList);

    // Load initial filter values for the default filter key (year)
    _loadFilterValues();
  }

  void _loadFilterValues() {
    filterValues = jsonData
        .map((data) => data[selectedFilterKey].toString())
        .toSet()
        .toList();
    selectedFilterValue = filterValues.isNotEmpty ? filterValues.first : '';
    _applyFilter();
  }

  void _applyFilter() {
    // Filter data based on the selected filter key and value
    final filteredData = jsonData
        .where(
            (data) => data[selectedFilterKey].toString() == selectedFilterValue)
        .toList();

    rowHeaders =
        filteredData.map((data) => data[rowKey].toString()).toSet().toList();
    columnHeaders =
        filteredData.map((data) => data[columnKey].toString()).toSet().toList();

    setState(() {});
  }

  void _clearFilters() {
    setState(() {
      selectedFilterKey = 'year'; // Reset to default filter key
      selectedFilterValue = ''; // Clear the selected filter value
      _loadFilterValues(); // Reload filter values
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for selecting the filter key (e.g., year, category, region)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Filter by: '),
            DropdownButton<String>(
              value: selectedFilterKey,
              onChanged: (value) {
                setState(() {
                  selectedFilterKey = value!;
                  _loadFilterValues(); // Reload filter values based on the new filter key
                });
              },
              items: filterKeys.map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
          ],
        ),

        // Dropdown for selecting the filter value (based on selected filter key)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Value: '),
            DropdownButton<String>(
              value: selectedFilterValue,
              onChanged: (value) {
                setState(() {
                  selectedFilterValue = value!;
                  _applyFilter();
                });
              },
              items: filterValues.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),

        // Button to clear filters
        ElevatedButton(
          onPressed: _clearFilters,
          child: Text('Clear Filters'),
        ),

        // The Pivot Table
        Expanded(
          child: jsonData.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: buildColumns(),
                    rows: buildRows(),
                  ),
                ),
        ),
      ],
    );
  }

  List<DataColumn> buildColumns() {
    List<DataColumn> columns = [
      DataColumn(label: Text('$rowKey/$columnKey')),
    ];
    columns
        .addAll(columnHeaders.map((header) => DataColumn(label: Text(header))));
    columns.add(DataColumn(label: Text('Total')));
    return columns;
  }

  List<DataRow> buildRows() {
    List<DataRow> rows = [];

    for (String rowHeader in rowHeaders) {
      List<DataCell> cells = [DataCell(Text(rowHeader))];

      int rowTotal = 0;
      int rowCount = 0; // For counting in case of String

      for (String columnHeader in columnHeaders) {
        final values = jsonData
            .where((data) =>
                data[rowKey] == rowHeader && data[columnKey] == columnHeader)
            .map((data) => data[valueKey])
            .toList();

        if (values.isNotEmpty) {
          // Check if the valueKey is int (sum) or String (count)
          if (values.first is int) {
            final value = values.reduce((a, b) => a + b);
            cells.add(DataCell(Text(value.toString())));
            rowTotal += value as int;
          } else if (values.first is String) {
            final count = values.length; // Count occurrences
            cells.add(DataCell(Text(count.toString())));
            rowCount += count;
          }
        } else {
          cells.add(DataCell(Text('0')));
        }
      }

      // Add total based on value type
      if (jsonData.first[valueKey] is int) {
        cells.add(DataCell(Text(rowTotal.toString())));
      } else {
        cells.add(DataCell(Text(rowCount.toString()))); // Total count
      }

      rows.add(DataRow(cells: cells));
    }

    // Add total row
    List<DataCell> totalRowCells = [DataCell(Text('Total'))];
    int grandTotal = 0;
    int grandCount = 0;

    for (String columnHeader in columnHeaders) {
      final values = jsonData
          .where((data) => data[columnKey] == columnHeader)
          .map((data) => data[valueKey])
          .toList();

      if (values.isNotEmpty && values.first is num) {
        // Filter only the numeric values (int or double) for summation
        final numericValues = values.where((v) => v is num).toList();
        final columnTotal = numericValues.fold(
            0.0, (prev, curr) => prev + (curr as num).toDouble());
        totalRowCells.add(DataCell(Text(columnTotal.toString())));
        grandTotal += columnTotal.toInt();
      } else if (values.isNotEmpty && values.first is String) {
        // Count occurrences of string values
        final columnCount = values.where((v) => v is String).length;
        totalRowCells.add(DataCell(Text(columnCount.toString())));
        grandCount += columnCount;
      } else {
        totalRowCells.add(DataCell(Text('0')));
      }
    }

    // Display final grand total or count
    if (jsonData.first[valueKey] is int) {
      totalRowCells.add(DataCell(Text(grandTotal.toString())));
    } else {
      totalRowCells.add(DataCell(Text(grandCount.toString()))); // Grand count
    }

    rows.add(DataRow(cells: totalRowCells));

    return rows;
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

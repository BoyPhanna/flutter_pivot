import 'dart:convert';
import 'package:flutter/material.dart';

class PivotTable extends StatefulWidget {
  final String rowKey;
  final String columnKey;
  final String valueKey;
  final String selectedFilterKey;
  final String json;
  const PivotTable({
    super.key,
    required this.rowKey,
    required this.columnKey,
    required this.valueKey,
    required this.selectedFilterKey,
    required this.json,
  });
  @override
  _PivotTableState createState() => _PivotTableState();
}

class _PivotTableState extends State<PivotTable> {
  List<Map<String, dynamic>> jsonData = [];
  List<String> rowHeaders = [];
  List<String> columnHeaders = [];
  List<String> filterValues = [];
  String selectedFilterValue = '';
  String selectedFilterKey = 'year';

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
    selectedFilterKey = widget.selectedFilterKey;
    columnKey = widget.columnKey;
    rowKey = widget.rowKey;
    valueKey = widget.valueKey;

    _loadData();
  }

  void _loadData() {
    // Sample JSON Data
    String jsonString = widget.json;

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
            print("Values : ${values.first}");
            final value = values.reduce((a, b) => a + b);
            cells.add(DataCell(Text(value.toString())));
            rowTotal += value as int;
          } else if (values.first is String) {
            print("String value: ${values.first}");
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

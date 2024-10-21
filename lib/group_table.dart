import 'package:flutter/material.dart';

class GroupedPaginatedTable extends StatefulWidget {
  @override
  _GroupedPaginatedTableState createState() => _GroupedPaginatedTableState();
}

class _GroupedPaginatedTableState extends State<GroupedPaginatedTable> {
  // Sample data
  List<Map<String, dynamic>> data = [
    {
      "category": "Fruits",
      "region": "North",
      "year": 2023,
      "cost": 7000,
      "sales": 1200
    },
    {
      "category": "Fruits",
      "region": "South",
      "year": 2023,
      "cost": 7000,
      "sales": 1500
    },
    {
      "category": "Vegetables",
      "region": "North",
      "year": 2022,
      "cost": 7000,
      "sales": 1100
    },
    {
      "category": "Vegetables",
      "region": "GTA",
      "year": 2023,
      "cost": 7000,
      "sales": 900
    },
    {
      "category": "Fruits",
      "region": "GTA",
      "year": 2022,
      "cost": 7000,
      "sales": 1000
    },
    {
      "category": "Vegetables",
      "region": "South",
      "year": 2023,
      "cost": 7000,
      "sales": 900
    },
    {
      "category": "Vegetables",
      "region": "KSK",
      "year": 2022,
      "cost": 7000,
      "sales": 1000
    },
    {
      "category": "Vegetables",
      "region": "TK",
      "year": 2021,
      "cost": 9000,
      "sales": 1000
    },
  ];

  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grouped and Paginated Table")),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          header: Text('Sales Data'),
          rowsPerPage: rowsPerPage,
          onRowsPerPageChanged: (value) {
            setState(() {
              rowsPerPage = value!;
            });
          },
          availableRowsPerPage: [5, 10, 20],
          columns: [
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Region')),
            DataColumn(label: Text('Year')),
            DataColumn(label: Text('Cost')),
            DataColumn(label: Text('Sales')),
          ],
          source: _DataSource(data),
        ),
      ),
    );
  }
}

// Data source for PaginatedDataTable
class _DataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  _DataSource(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];

    // Group header for new categories
    if (index == 0 || data[index - 1]['category'] != row['category']) {
      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text(row['category'],
              style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(SizedBox()), // Empty cells for the rest
          DataCell(SizedBox()),
          DataCell(SizedBox()),
          DataCell(SizedBox()),
        ],
      );
    }

    // Regular rows
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('')), // Leave category empty after the first row
        DataCell(Text(row['region'])),
        DataCell(Text(row['year'].toString())),
        DataCell(Text(row['cost'].toString())),
        DataCell(Text(row['sales'].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

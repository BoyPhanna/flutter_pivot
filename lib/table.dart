import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataGridExample extends StatelessWidget {
  final List<String>? groups;
  const DataGridExample({super.key, this.groups});

  DataGridSource getgroup(List<String> groups, DataGridSource datasource) {
    if (groups.length <= 3)
      for (int i = 0; i < groups.length; i++) {
        datasource
            .addColumnGroup(ColumnGroup(name: groups[i], sortGroupRows: true));
      }
    return datasource;
  }

  @override
  Widget build(BuildContext context) {
    final EmployeeDataSource employeeDataSource = EmployeeDataSource(
      employees: [
        Employee(1, 'John Doe', 'Manager', 50000),
        Employee(2, 'Jane Smith', 'Developer', 45000),
        Employee(3, 'Alice Johnson', 'Designer', 40000),
        Employee(4, 'Bob Brown', 'Tester', 35000),
        Employee(5, 'Tony', 'Tester', 35000),
        Employee(3, 'Natachar', 'Tester', 2000),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ផ្លូវទៅកាន់ Pivot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: SfDataGrid(
        onColumnDragging: (details) {
          return true;
        },
        allowExpandCollapseGroup: true,
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: GridLinesVisibility.both,
        columnDragFeedbackBuilder: (context, column) {
          return Material(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Text(column.columnName),
            ),
          );
        },
        allowColumnsDragging: true,
        onCellLongPress: (details) {},
        source: (groups == null)
            ? employeeDataSource
            : getgroup(groups!, employeeDataSource),
        groupCaptionTitleFormat: '{Key}',
        columns: <GridColumn>[
          GridColumn(
              visible: closeClolumnGroup("ID"),
              columnName: 'ID',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('ID',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          GridColumn(
              visible: closeClolumnGroup("Name"),
              columnName: 'Name',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Name',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          GridColumn(
              visible: closeClolumnGroup("Designation"),
              columnName: 'Designation',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Designation',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          GridColumn(
              visible: closeClolumnGroup("Salary"),
              columnName: 'Salary',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Salary',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }

  bool closeClolumnGroup(String name) {
    if (groups != null) {
      if (groups!.length <= 3)
        return !groups!.contains(name);
      else
        return true;
    } else
      return true;
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;
  final String name;
  final String designation;
  final double salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    dataGridRows = employees
        .map<DataGridRow>((employee) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'ID', value: employee.id),
              DataGridCell<String>(columnName: 'Name', value: employee.name),
              DataGridCell<String>(
                  columnName: 'Designation', value: employee.designation),
              DataGridCell<double>(
                  columnName: 'Salary', value: employee.salary),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;
  int i = 0;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final color = i % 2 == 0 ? Colors.white : Colors.grey[200];
    i++;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((cell) {
      return Container(
        color: color,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(cell.value.toString()),
      );
    }).toList());
  }

  @override
  Widget? buildGroupCaptionCellWidget(
      RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Text(summaryValue));
  }
}

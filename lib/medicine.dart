
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutternewtest/sqldata/sqlrequest.dart';

class Medicine extends StatefulWidget {
  const Medicine({Key? key}) : super(key: key);

  @override
  State<Medicine> createState() => MedicineState();

}

class MedicineState extends State<Medicine> {

  List<DataColumn2> columnList = [
    const DataColumn2(
      label: Text('名称'),
      size: ColumnSize.L,
    ),
    const DataColumn2(
      label: Text('归经'),
      size: ColumnSize.L,
    ),
    const DataColumn2(
      label: Text('性味'),
      size: ColumnSize.L,
    ),
    const DataColumn2(
      label: Text('功能'),
      size: ColumnSize.L,
    ),
    const DataColumn2(
      label: Text('注意'),
      size: ColumnSize.L,
      numeric: true,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SqlRequest.loadDatas();
  }

  getBody(){
    return Center(
      child:
      DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          columns: columnList,
          rows: List<DataRow>.generate(
              100,
                  (index) =>
                  DataRow(cells: [
                    DataCell(Text('A' * (10 - index % 10))),
                    DataCell(Text('B' * (10 - (index + 5) % 10))),
                    DataCell(Text('C' * (15 - (index + 5) % 10))),
                    DataCell(Text('D' * (15 - (index + 10) % 10))),
                    DataCell(Text(((index + 0.1) * 25.4).toString()))
                  ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Object title = ModalRoute.of(context)?.settings.arguments ?? Object();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title.toString()),
      ),
      body: getBody(),
    );
  }
}
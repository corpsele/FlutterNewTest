import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutternewtest/sqldata/sqlrequest.dart';
import 'package:flutternewtest/utils/globalutils.dart';

import 'medicinemodel.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Medicine extends StatefulWidget {
  // const Medicine({Key? key}) : super(key: key);

  Medicine({super.key}) {
    GlobalUtils.initDeviceW_H();
  }

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

  TextEditingController textEditingControllerMingCheng =
      TextEditingController();
  TextEditingController textEditingControllerGongNeng = TextEditingController();
  TextEditingController textEditingControllerZhuYi = TextEditingController();

  String strSelectedGuiJing = "";
  List<String> listGuiJing = ["", "心", "脾", "胃", "肝", "肾", "肠", "肺"];

  String strSelectedXingWei = "";
  List<String> listXingWei = ["", "甘", "寒", "凉", "温", "热", "平"];

  FocusNode focusNode = FocusNode();

  int pageSize = 0;
  int startIndex = 0;
  int arrayStartIndex = 0;
  int arrayPageSize = 10;

  List<MedicineModel>? medicineModelList;
  List<MedicineModel>? medicineModelPageList;

  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // SqlRequest.loadDatas();
    // SqlRequest.searchDatasByParams(
    //     textEditingControllerMingCheng.text,
    //     textEditingControllerGongNeng.text,
    //     strSelectedGuiJing,
    //     strSelectedXingWei,
    //     textEditingControllerZhuYi.text
    // );
    medicineModelList = [];
    medicineModelPageList = [];
  }

  getTableOrEmpty() {
    if ((medicineModelPageList?.length ?? 0) < 1) {
      return const Text(
        "暂无数据",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
        ),
      );
    } else {
      if((medicineModelPageList?.length ?? 0) < (medicineModelList?.length ?? 0)){
        return
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LimitedBox(
                maxHeight:
          GlobalUtils.screenH.toDouble() -
              50 -
              MediaQuery.of(context).padding.top -
              kBottomNavigationBarHeight - 60,
                child:
                DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  dataRowHeight: 200,
                  columns: columnList,
                  rows: getRows(),
                  // List<DataRow>.generate(medicineModelList?.length ?? 0,
                  //     (index) {
                  //   return DataRow(cells: [
                  //     DataCell(
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child: AutoSizeText(
                  //           medicineModelList?[index].mingCheng ?? "",
                  //           maxLines: 100,
                  //         ),
                  //       ),
                  //     ),
                  //     DataCell(
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child: AutoSizeText(
                  //             medicineModelList?[index].guiJing ?? ""),
                  //       ),
                  //     ),
                  //     DataCell(
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child: AutoSizeText(
                  //             medicineModelList?[index].xingWei ?? ""),
                  //       ),
                  //     ),
                  //     DataCell(
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child: AutoSizeText(
                  //           medicineModelList?[index].gongNeng ?? "",
                  //           maxLines: 100,
                  //         ),
                  //       ),
                  //     ),
                  //     DataCell(
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child:
                  //             AutoSizeText(medicineModelList?[index].zhuYi ?? ""),
                  //       ),
                  //     ),
                  //   ]);
                  // })),
                ),
              ),

              LimitedBox(
                maxHeight: 30,
                child:
                ElevatedButton(
                  onPressed: (){
                    print("================ (medicineModelPageList?.length ?? 0) + arrayPageSize = ${(medicineModelPageList?.length ?? 0) + arrayPageSize}");
                    print("================ (medicineModelPageList?.length ?? 0) - 1 = ${(medicineModelPageList?.length ?? 0) - 1}");
                    print("================ (medicineModelPageList?.length ?? 0) = ${(medicineModelPageList?.length ?? 0)}");
                    setState(() {
                      if((medicineModelList?.length ?? 0) > 0){
                        for(int i = 0; i < arrayPageSize; i++){
                          if(i < (medicineModelList?.length ?? 0) - 1){
                            MedicineModel model = medicineModelList?[i] ?? MedicineModel();
                            medicineModelPageList?.add(model);
                            medicineModelList?.removeAt(i);
                          }
                        }
                      }
                    });

                  },
                  child: const Text("加载跟多"),
                ),
              ),





            ],
          );

      }else{
        return DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          dataRowHeight: 200,
          columns: columnList,
          rows: getRows(),
          // List<DataRow>.generate(medicineModelList?.length ?? 0,
          //     (index) {
          //   return DataRow(cells: [
          //     DataCell(
          //       SingleChildScrollView(
          //         scrollDirection: Axis.vertical,
          //         child: AutoSizeText(
          //           medicineModelList?[index].mingCheng ?? "",
          //           maxLines: 100,
          //         ),
          //       ),
          //     ),
          //     DataCell(
          //       SingleChildScrollView(
          //         scrollDirection: Axis.vertical,
          //         child: AutoSizeText(
          //             medicineModelList?[index].guiJing ?? ""),
          //       ),
          //     ),
          //     DataCell(
          //       SingleChildScrollView(
          //         scrollDirection: Axis.vertical,
          //         child: AutoSizeText(
          //             medicineModelList?[index].xingWei ?? ""),
          //       ),
          //     ),
          //     DataCell(
          //       SingleChildScrollView(
          //         scrollDirection: Axis.vertical,
          //         child: AutoSizeText(
          //           medicineModelList?[index].gongNeng ?? "",
          //           maxLines: 100,
          //         ),
          //       ),
          //     ),
          //     DataCell(
          //       SingleChildScrollView(
          //         scrollDirection: Axis.vertical,
          //         child:
          //             AutoSizeText(medicineModelList?[index].zhuYi ?? ""),
          //       ),
          //     ),
          //   ]);
          // })),
        );
      }

    }
  }

  getRows() {
    return List<DataRow>.generate(medicineModelPageList?.length ?? 0, (index) {
      return DataRow(cells: [
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AutoSizeText(
              medicineModelPageList?[index].mingCheng ?? "",
              maxLines: 100,
            ),
          ),
        ),
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AutoSizeText(medicineModelPageList?[index].guiJing ?? ""),
          ),
        ),
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AutoSizeText(medicineModelPageList?[index].xingWei ?? ""),
          ),
        ),
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AutoSizeText(
              medicineModelPageList?[index].gongNeng ?? "",
              maxLines: 100,
            ),
          ),
        ),
        DataCell(
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AutoSizeText(medicineModelPageList?[index].zhuYi ?? ""),
          ),
        ),
      ]);
    });
  }

  getBody() {
    return Center(
      // child:
      // Padding(
      // padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // maxWidth: GlobalUtils.screenW.toDouble(),
            // maxHeight: 50,
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Container(
                //   alignment: Alignment.center,
                //   child:
                //   Text(
                //     "名称",
                //   ),
                // ),
                // SizedBox(
                //   width: 50,
                //   height: 100,
                //
                //   child:
                //
                // ),
                Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: textEditingControllerMingCheng,
                    decoration: const InputDecoration(
                        hintText: "名称", border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child:
                      // DropdownButton(
                      //     value: dropDownGuiJing, style: textStyleGuiJing,
                      //     icon: Icon(Icons.arrow_right), iconSize: 40, iconEnabledColor: Colors.green.withOpacity(0.7),
                      //     hint: Text('请选择地区'), isExpanded: true, underline: Container(height: 1, color: Colors.green.withOpacity(0.7)),
                      //     items: [
                      //       DropdownMenuItem(
                      //           child: Row(children: <Widget>[Text('北京'), SizedBox(width: 10), Icon(Icons.ac_unit) ]),
                      //           value: 1),
                      //       DropdownMenuItem(
                      //           child: Row(children: <Widget>[Text('天津'), SizedBox(width: 10), Icon(Icons.content_paste) ]),
                      //           value: 2),
                      //       DropdownMenuItem(
                      //           child: Row(children: <Widget>[Text('河北', style: TextStyle(color: Colors.purpleAccent, fontSize: 16)), SizedBox(width: 10), Icon(Icons.send, color: Colors.purpleAccent) ]),
                      //           value: 3)
                      //     ],
                      //     onChanged: (value) {
                      //       setState((){
                      //         // dropDownGuiJing = value.toString();
                      //       });
                      //     }),
                      DropdownButton<String>(
                    value: strSelectedGuiJing,
                    onChanged: (value) {
                      setState(() {
                        strSelectedGuiJing = value.toString();
                      });
                    },

                    hint: const Center(
                      child: Text(
                        '归经',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Hide the default underline
                    underline: Container(
                        height: 1, color: Colors.green.withOpacity(0.7)),
                    // set the color of the dropdown menu
                    dropdownColor: Colors.white,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                    isExpanded: true,

                    // The list of options
                    items: listGuiJing
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // e == "" ? "归经" : e,
                                  e,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ))
                        .toList(),

                    // Customize the selected item
                    selectedItemBuilder: (BuildContext context) => listGuiJing
                        .map((e) => Center(
                              child: Text(
                                e == "" ? "归经" : e,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child:
                      // DropdownButton(
                      //     value: dropDownGuiJing, style: textStyleGuiJing,
                      //     icon: Icon(Icons.arrow_right), iconSize: 40, iconEnabledColor: Colors.green.withOpacity(0.7),
                      //     hint: Text('请选择地区'), isExpanded: true, underline: Container(height: 1, color: Colors.green.withOpacity(0.7)),
                      //     items: [
                      //       DropdownMenuItem(
                      //           child: Row(children: <Widget>[Text('北京'), SizedBox(width: 10), Icon(Icons.ac_unit) ]),
                      //           value: 1),
                      //       DropdownMenuItem(
                      //           child: Row(children: <Widget>[Text('天津'), SizedBox(width: 10), Icon(Icons.content_paste) ]),
                      //           value: 2),
                      //       DropdownMenuItem(
                      //           child: Row(children: <Widget>[Text('河北', style: TextStyle(color: Colors.purpleAccent, fontSize: 16)), SizedBox(width: 10), Icon(Icons.send, color: Colors.purpleAccent) ]),
                      //           value: 3)
                      //     ],
                      //     onChanged: (value) {
                      //       setState((){
                      //         // dropDownGuiJing = value.toString();
                      //       });
                      //     }),
                      DropdownButton<String>(
                    value: strSelectedXingWei,
                    onChanged: (value) {
                      setState(() {
                        strSelectedXingWei = value.toString();
                      });
                    },

                    hint: const Center(
                      child: Text(
                        '性味',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Hide the default underline
                    underline: Container(
                        height: 1, color: Colors.green.withOpacity(0.7)),
                    // set the color of the dropdown menu
                    dropdownColor: Colors.white,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                    isExpanded: true,

                    // The list of options
                    items: listXingWei
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // e == "" ? "归经" : e,
                                  e,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ))
                        .toList(),

                    // Customize the selected item
                    selectedItemBuilder: (BuildContext context) => listXingWei
                        .map((e) => Center(
                              child: Text(
                                e == "" ? "性味" : e,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: textEditingControllerGongNeng,
                    decoration: const InputDecoration(
                        hintText: "功能", border: OutlineInputBorder()),
                  ),
                ),

                Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: textEditingControllerZhuYi,
                    decoration: const InputDecoration(
                        hintText: "注意", border: OutlineInputBorder()),
                    focusNode: focusNode,
                  ),
                ),

                Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      hideKeyboard();
                      arrayStartIndex = 0;
                      SqlRequest.searchDatasByParamsLimit(
                        textEditingControllerMingCheng.text,
                        textEditingControllerGongNeng.text,
                        strSelectedGuiJing,
                        strSelectedXingWei,
                        textEditingControllerZhuYi.text,
                        startIndex,
                        pageSize,
                      ).then((value) {
                        setState(() {
                          medicineModelList = value;
                          if((medicineModelList?.length ?? 0) > 0){
                            for(int i = 0; i < arrayPageSize; i++){
                              if(i < (medicineModelList?.length ?? 0) - 1){
                                MedicineModel model = medicineModelList?[i] ?? MedicineModel();
                                medicineModelPageList?.add(model);
                                medicineModelList?.removeAt(i);
                              }
                            }
                          }
                        });
                      });
                    },
                    style: const ButtonStyle(
                      textStyle:
                          MaterialStatePropertyAll(TextStyle(fontSize: 18)),
                    ),
                    child: const Text("搜索"),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: 1,
          //   height: 100,
          // ),
          //   SizedBox(
          //
          //     width: 200,
          //     height: 400,
          //     child:
          LimitedBox(
            maxWidth: GlobalUtils.screenW.toDouble(),
            maxHeight: GlobalUtils.screenH.toDouble() -
                50 -
                MediaQuery.of(context).padding.top -
                kBottomNavigationBarHeight,
            child: getTableOrEmpty(),
          ),
        ],
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Object title = ModalRoute.of(context)?.settings.arguments ?? Object();
    // TODO: implement build
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
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
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

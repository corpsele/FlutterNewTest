import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternewtest/utils/globalutils.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:ncmdump/ncmdump.dart';

class NCMDump extends StatefulWidget {
  NCMDump({super.key}) {
    GlobalUtils.initDeviceW_H();
  }

  @override
  State<NCMDump> createState() => NCMDumpState();
}

class NCMDumpState extends State<NCMDump> {
  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  final double appBarHeight = 44;

  late List<File> listFiles;

  List<TableRow> listRow = [
    TableRow(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: const Text(
          "",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    ]),
  ];

  @override
  void initState() {
    super.initState();

    listFiles = [];
  }

  Future<void> restoreData(List<File> files) async {
    setState(() {
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        listRow.add(
          TableRow(children: [
            Container(
              alignment: Alignment.centerLeft,

              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text("序号$i  ${file.path}"
                ,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ]),
        );
      }
    });
  }

  Future<List<File>> setPickupFiles() async {
    List<File> files = [];
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      for (int i = 0; i< files.length; i++){
        File file = files[i];
        String extension = p.extension(file.path);
        if(extension.isEmpty){
          files.removeAt(i);
        }else if(extension.contains("ncm") == false){
          files.removeAt(i);
        }
      }
    } else {
      // User canceled the picker
    }
    return files;
  }

  Future<void> doDumpMethod() async{
    print("listFiles = $listFiles");
    for(int i = 0; i < listFiles.length; i++){
      File file = listFiles[i];
      final ncm = NCM();

      final raw = await file.readAsBytes();
      ncm.setRaw(raw);
      try {
        ncm.parse();
      }catch(e){
        print("e = $e");
      }
      await File('a.${ncm.meta.format}').writeAsBytes(ncm.music);
    }

  }

  getBody() {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: MaterialButton(
                  child: const Text("选择文件"),
                  onPressed: () {
                    setPickupFiles().then((value) {
                      listFiles = value;
                      restoreData(listFiles);
                    });
                  },
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                height: 50,
                child: MaterialButton(
                  child: const Text("转换"),
                  onPressed: () {
                    print("listFiles = $listFiles");
                    doDumpMethod();
                  },
                ),
              ),
            ],
          ),

          SizedBox(
            width: GlobalUtils.screenW.toDouble(),
            height: GlobalUtils.screenH - 50 - appBarHeight - MediaQuery.of(context).padding.top,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              border: TableBorder.all(
                color: Colors.black,
                width: 1,
              ),
              children: listRow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Object title = ModalRoute.of(context)?.settings.arguments ?? Object();

    // final GlobalKey appBarKey = GlobalKey();
    //
    // final double appBarHeight =
    //     (appBarKey.currentContext!.findRenderObject() as AppBar)
    //         .preferredSize
    //         .height;

    // TODO: implement build
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(title.toString()),
          ),
        ),
        body: getBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

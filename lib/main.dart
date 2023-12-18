import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:data_table_2/data_table_2.dart';

import 'medicine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<TableRow> listRow = [
    TableRow(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: const Text(
            "中药食疗搜",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18,),
          ),
        ),
        // Container(
        //   child: Text(""),
        // ),
        // Container(
        //   padding: const EdgeInsets.fromLTRB(42 + 50, 0, 0, 0),
        //   child: Text(
        //     "2",
        //     // textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 18,),
        //   ),
        // ),
      ],
    ),
  ];

  List<String> words = [
    "中药食疗搜",
  ];

  final menus = <Map>[
    {"id": "0", "name": "中药食疗搜"},
  ];

  static const loadingTag = "##loading##";

  List<DataColumn2> columnMainList = [
    const DataColumn2(
      label: Text('中药食疗搜'),
      size: ColumnSize.L,
    ),
  ];

  List<DataColumn2> columnList = [
    DataColumn2(
      label: Text('名称'),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Text('归经'),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Text('性味'),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Text('功能'),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Text('注意'),
      size: ColumnSize.L,
      numeric: true,
    ),
  ];

  // List<String> listHeader = [
  //   "名称",
  //   "归经",
  // ];

  final PaginationController _paginationController = PaginationController(
    rowCount: 1,
    rowsPerPage: 10,
  );

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  getMainBody(){
    return ListView.separated(
        itemBuilder: (context, index) {
          // receiveData();
          if (words[index] == loadingTag) {
            if (words.length <= menus.length) {
              receiveData();
              return Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: const Text(
                  "没有更多了",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          }
          // return ListTile(
          //   title: Text(words[index]),
          // );
          return getItems(index);
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemCount: words.length);
  }

  receiveData() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        words.insertAll(
            words.length - 1,
            // words.length,
            List.generate(menus.length, (index) {
              // return "words $index";
              Map mapTmp = menus[index];
              return mapTmp["name"];
            }));
      });
    });
  }

  getItems(int index) {
    return GestureDetector(
      child: ListTile(
        title: Text(words[index]),
      ),
      onTap: () {
        if (kDebugMode) {
          print("点击到第$index 是 ${words[index]}");
        }
        setState(() {
          onItemClick(index);
        });
      },
      onLongPress: () {
        setState(() {
          onLongPressedAction(index);
        });
      },
    );
  }

  onItemClick(int index) {
    switch (index){
      case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Medicine(),
                // Pass the arguments as part of the RouteSettings. The
                // DetailScreen reads the arguments from these settings.
                settings: RouteSettings(
                  arguments: words[index],
                ),
              ),
            );
        break;
    }
    // if (Platform.isMacOS) {
    //   switch (index){
    //     case 7:
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const HuaWenXingKaiEditPage(),
    //           // Pass the arguments as part of the RouteSettings. The
    //           // DetailScreen reads the arguments from these settings.
    //           settings: RouteSettings(
    //             arguments: words[index],
    //           ),
    //         ),
    //       );
    //       break;
    //     case 8:
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const XingKaiTextEditPage(),
    //           // Pass the arguments as part of the RouteSettings. The
    //           // DetailScreen reads the arguments from these settings.
    //           settings: RouteSettings(
    //             arguments: words[index],
    //           ),
    //         ),
    //       );
    //       break;
    //     default:
    //       initDesktopWebView(index);
    //       break;
    //   }
    //   return;
    // } else if (Platform.isAndroid) {
    //   // _sendData();
    // }

    // CherryToast.info(title: Text("点击了第$index 是 ${words[index]}")).show(context);
    // MotionToast.info(description: Text("点击了第$index 是 ${words[index]}"))
    //     .show(context);
  }

  onLongPressedAction(int index) {
    //粘贴文本
    // Clipboard.setData(ClipboardData(text: words[index]));
    // CherryToast.info(title: Text("长点击了第$index 是 ${words[index]}"))
    //     .show(context);
    // MotionToast.info(description: Text("长点击了第$index 是 ${words[index]}"))
    //     .show(context);
  }

  getBodyTest() {
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

  getBody() {
    return
      Center(
        child:
        Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "名称",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18,),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12 + 50),
                  child: const Text(
                    "归经",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18,),
                  ),
                ),
              ],
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(

                ),
              },
              border: TableBorder.all(color: Colors.black, width: 1,),
              children: listRow,
            )
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
      getMainBody(),
      // Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     //
      //     // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
      //     // action in the IDE, or press "p" in the console), to see the
      //     // wireframe for each widget.
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

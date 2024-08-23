import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutternewtest/medicinemodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert' as convert;

class SqlRequest {
  SqlRequest._();

  static SqlRequest _instance = SqlRequest._();

  factory SqlRequest() => _instance;

  late List<MedicineModel> listDatas;

  late Database database;
  static late Database db;

  Future init() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "zysjyj.db");
    print('数据库存储路径path:' + path);
    //所有的sql语句
    // CreateTableSqls  sqlTables = CreateTableSqls();
    //所有的sql语句
    // Map<String,String> allTableSqls = sqlTables.getAllTables();
    try {
      db = await openDatabase(path);
    } catch (e) {
      print('CreateTables init Error $e');
    }
    //检查需要生成的表
    // List<String> noCreateTables = await getNoCreateTables(allTableSqls);
    // print('noCreateTables:'+noCreateTables.toString());
    // if (noCreateTables.length>0) {
    //   //创建新表
    //   // 关闭上面打开的db，否则无法执行open
    //   db.close();
    //   db = await openDatabase(
    //       path,
    //       version: 1,
    //       onCreate: (Database db,int version) async{
    //
    //         print('db created version is $version');
    //       },
    //       onOpen: (Database db)async{
    //         noCreateTables.forEach((sql) async{
    //           await db.execute(allTableSqls[sql]);
    //         });
    //         print('db补完表已打开');
    //       });
    // }else{
    //   print("表都存在，db已打开");
    // }
    List tableMaps = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    print('所有表:' + tableMaps.toString());
    // db.close();
    // print("db已关闭");
  }

  static Future<void> copyDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zysjyj.db');

    // 检查SQLite .db文件是否已复制到设备
    bool exists = await databaseExists(path);

    if (!exists) {
      // 如果SQLite .db文件不存在，则复制它
      try {
        // 从assets目录复制SQLite .db文件到设备上的合适位置
        ByteData data = await rootBundle.load('assets/databases/zysjyj.db');
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes);
      } catch (e) {
        print(e);
      }
    }
  }

  // 打开SQLite数据库连接，并执行查询语句
  Future<void> queryDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zysjyj.db');

    // 打开SQLite数据库连接
    db = await openDatabase(path);

    // 执行查询语句
    // List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM zysjyj');

    // 处理查询结果
    // ...
  }

  static Future<void> loadDatas() async {
    // String sql = await rootBundle.loadString('assets/resources/sql/excute.sql');
    // await _instance.init();
    await copyDatabase();

    String sql = "select * from zysjyj";
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zysjyj.db');

    // 打开SQLite数据库连接

    try {
      db = await openDatabase(path);
      List tableMaps = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
      print('所有表:' + tableMaps.toString());
      await db.rawQuery(sql);
      db.close();
      print("db已关闭");
    } catch (e) {
      print("error = $e");
    }
  }

  static Future<List<MedicineModel>> searchDatasByParams(String mingCheng, String gongNeng,
      String guiJing, String xingWei, String zhuYi) async {
    _instance.listDatas = [];
    // String sql = await rootBundle.loadString('assets/resources/sql/excute.sql');
    // await _instance.init();
    await copyDatabase();

    String sql =
        "select * from zysjyj where MingCheng like ? or GongNengZZ like ? or GuiJing like ? or XingWei like ? or ZhuYi like ?";
    // String sql = 'SELECT * FROM my_table WHERE name LIKE ?';
    // List<Map> maps = await db.rawQuery(sql, ['%' + name + '%']);

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zysjyj.db');

    // 打开SQLite数据库连接

    try {
      db = await openDatabase(path);
      List tableMaps = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
      print('所有表:$tableMaps');
      mingCheng = mingCheng.isNotEmpty ? '%$mingCheng%' : "";
      gongNeng = gongNeng.isNotEmpty ? '%$gongNeng%' : "";
      guiJing = guiJing.isNotEmpty ? '%$guiJing%' : "";
      xingWei = xingWei.isNotEmpty ? '%$xingWei%' : "";
      zhuYi = zhuYi.isNotEmpty ? '%$zhuYi%' : "";
      String strWhere = "";
      List<String> listWhereArgs = [];
      if(mingCheng.isNotEmpty){
        strWhere = "MingCheng like ?";
        listWhereArgs.add(mingCheng);
      }
      if(gongNeng.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and GongNengZZ like ?";
        }
        else
        {
          strWhere = "GongNengZZ like ?";
        }
        listWhereArgs.add(gongNeng);
      }
      if(guiJing.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and GuiJing like ?";
        }
        else
        {
          strWhere = "GuiJing like ?";
        }
        listWhereArgs.add(guiJing);
      }
      if(xingWei.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and XingWei like ?";
        }
        else
        {
          strWhere = "XingWei like ?";
        }
        listWhereArgs.add(xingWei);
      }
      if(zhuYi.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and ZhuYi like ?";
        }
        else
        {
          strWhere = "ZhuYi like ?";
        }
        listWhereArgs.add(zhuYi);
      }
      List<Map<String, Object?>> listData = await db.query(
        "zysjyj",
        distinct: false,
        columns: ["MingCheng", "GongNengZZ", "GuiJing", "XingWei", "ZhuYi"],
        where:
            strWhere,
        whereArgs: listWhereArgs,
      );
      // List listData = await db.rawQuery(sql, [mingCheng, '%$gongNeng%', '%$guiJing%', '%$xingWei%', '%$zhuYi%']);
      print("listData length = ${listData.length}");

      _instance.listDatas = await MedicineModel.fromList(listData);
      // if(listData.isNotEmpty){
      //   listData.map((json) {
      //     print("map json = $json");
      //     MedicineModel model = MedicineModel.fromJson(json);
      //     _instance.listDatas.add(model);
      //   });
      // }
      db.close();
      print("db已关闭");
    } catch (e) {
      print("error = $e");
    }
    return _instance.listDatas;
  }

  static Future<List<MedicineModel>> searchDatasByParamsLimit(String mingCheng, String gongNeng,
      String guiJing, String xingWei, String zhuYi, int index, int length) async {
    _instance.listDatas = [];
    // String sql = await rootBundle.loadString('assets/resources/sql/excute.sql');
    // await _instance.init();
    await copyDatabase();

    String sql =
        "select * from zysjyj where MingCheng like ? or GongNengZZ like ? or GuiJing like ? or XingWei like ? or ZhuYi like ?";
    // String sql = 'SELECT * FROM my_table WHERE name LIKE ?';
    // List<Map> maps = await db.rawQuery(sql, ['%' + name + '%']);

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'zysjyj.db');

    // 打开SQLite数据库连接

    try {
      db = await openDatabase(path);
      List tableMaps = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
      print('所有表:$tableMaps');
      mingCheng = mingCheng.isNotEmpty ? '%$mingCheng%' : "";
      gongNeng = gongNeng.isNotEmpty ? '%$gongNeng%' : "";
      guiJing = guiJing.isNotEmpty ? '%$guiJing%' : "";
      xingWei = xingWei.isNotEmpty ? '%$xingWei%' : "";
      zhuYi = zhuYi.isNotEmpty ? '%$zhuYi%' : "";
      String strWhere = "";
      List<String> listWhereArgs = [];
      if(mingCheng.isNotEmpty){
        strWhere = "MingCheng like ?";
        listWhereArgs.add(mingCheng);
      }
      if(gongNeng.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and GongNengZZ like ?";
        }
        else
        {
          strWhere = "GongNengZZ like ?";
        }
        listWhereArgs.add(gongNeng);
      }
      if(guiJing.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and GuiJing like ?";
        }
        else
        {
          strWhere = "GuiJing like ?";
        }
        listWhereArgs.add(guiJing);
      }
      if(xingWei.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and XingWei like ?";
        }
        else
        {
          strWhere = "XingWei like ?";
        }
        listWhereArgs.add(xingWei);
      }
      if(zhuYi.isNotEmpty){
        if(strWhere.isNotEmpty){
          strWhere = "$strWhere and ZhuYi like ?";
        }
        else
        {
          strWhere = "ZhuYi like ?";
        }
        listWhereArgs.add(zhuYi);
      }
      if(index > 0 && length > 0){
        strWhere = "$strWhere LIMIT $index, $length";
      }else if(index > 0 && length == 0){
        strWhere = "$strWhere LIMIT $index, 10";
      }else if(index == 0 && length > 0){
        strWhere = "$strWhere LIMIT 0, $length";
      }
      // else if(index == 0 && length == 0){
      //   strWhere = "$strWhere LIMIT 0, 10";
      // }
      List<Map<String, Object?>> listData = [];
      if(strWhere.isEmpty || listWhereArgs.isEmpty){
        listData = await db.query(
          "zysjyj",
          distinct: false,
          columns: ["MingCheng", "GongNengZZ", "GuiJing", "XingWei", "ZhuYi"],
        );
      }else{
        listData = await db.query(
          "zysjyj",
          distinct: false,
          columns: ["MingCheng", "GongNengZZ", "GuiJing", "XingWei", "ZhuYi"],
          where:
          strWhere,
          whereArgs: listWhereArgs,
        );
      }

      // List listData = await db.rawQuery(sql, [mingCheng, '%$gongNeng%', '%$guiJing%', '%$xingWei%', '%$zhuYi%']);
      print("listData length = ${listData.length}");

      _instance.listDatas = await MedicineModel.fromList(listData);
      // if(listData.isNotEmpty){
      //   listData.map((json) {
      //     print("map json = $json");
      //     MedicineModel model = MedicineModel.fromJson(json);
      //     _instance.listDatas.add(model);
      //   });
      // }
      db.close();
      print("db已关闭");
    } catch (e) {
      print("error = $e");
    }
    return _instance.listDatas;
  }
}

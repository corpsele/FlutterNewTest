class MedicineModel {
  String? mingCheng;
  String? guiJing;
  String? xingWei;
  String? gongNeng;
  String? zhuYi;

  MedicineModel({
    this.mingCheng,
    this.guiJing,
    this.xingWei,
    this.gongNeng,
    this.zhuYi,
  });

  MedicineModel.fromJson(Map<String, dynamic> json) {
    mingCheng = json["MingCheng"];
    guiJing = json["GuiJing"];
    xingWei = json["XingWei"];
    gongNeng = json["GongNengZZ"];
    zhuYi = json["ZhuYi"];
  }

  // list.map((e) {
  // Map<String, Object> map = e;
  // mingCheng = e["MingCheng"] as String;
  // guiJing = e["GuiJing"] as String;
  // xingWei = e["XingWei"] as String;
  // gongNeng = e["GongNengZZ"] as String;
  // zhuYi = e["ZhuYi"] as String;
  // MedicineModel model = MedicineModel(mingCheng: mingCheng, guiJing: guiJing,xingWei: xingWei,gongNeng: gongNeng,zhuYi: zhuYi);
  //
  // });
  static Future<List<MedicineModel>> fromList(List<Map<String, Object?>> list) async {
    List<MedicineModel> mms = [];
    for (var element in list) {
      Map<String, Object?> map = element;
      String mingCheng = map["MingCheng"] == null ? "" : map["MingCheng"] as String;
      String guiJing = map["GuiJing"] == null ? "" : map["GuiJing"] as String;
      String xingWei = map["XingWei"] == null ? "" : map["XingWei"] as String;
      String gongNeng = map["GongNengZZ"] == null ? "" : map["GongNengZZ"] as String;
      String zhuYi = map["ZhuYi"] == null ? "" : map["ZhuYi"] as String;
      MedicineModel model = MedicineModel(
          mingCheng: mingCheng,
          guiJing: guiJing,
          xingWei: xingWei,
          gongNeng: gongNeng,
          zhuYi: zhuYi);
      mms.add(model);
    }
    return mms;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["MingCheng"] = mingCheng;
    data["GuiJing"] = guiJing;
    data["XingWei"] = xingWei;
    data["GongNengZZ"] = gongNeng;
    data["ZhuYi"] = zhuYi;
    return data;
  }
}

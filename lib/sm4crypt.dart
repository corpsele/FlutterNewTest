

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternewtest/sm4cryptvm.dart';
import 'package:flutternewtest/utils/globalutils.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class SM4Crypt extends StatefulWidget {
  SM4Crypt({super.key}){
    GlobalUtils.initDeviceW_H();
  }

  @override
  State<SM4Crypt> createState() => SM4CryptState();
}

class SM4CryptState extends State<SM4Crypt> {

  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
  TextEditingController decryptController = TextEditingController();
  TextEditingController encryptController = TextEditingController();
  bool isEncypt = true;
  late BuildContext thisContext;

  getBody(){
    return Center(
      child:
      Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: GlobalUtils.screenW.toDouble(),
            height: 200,
            color: Colors.white,
            child:
            TextField(
              controller: decryptController,
              maxLines: null,
              decoration:
              const InputDecoration(
                  labelText: "输入明文信息",
                border:
                OutlineInputBorder(
                  borderSide:
                    BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                ),
              ),
            ),
          ),
          const Spacer(
          ),
          Container(
            width: GlobalUtils.screenW.toDouble(),
            height: 200,
            color: Colors.white,
            child:
            TextField(
              controller: encryptController,
              maxLines: null,
              decoration:
              const InputDecoration(
                  labelText: "输入加密信息",
                border:
                OutlineInputBorder(
                  borderSide:
                  BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child:
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child:
                  Switch(
                    value: isEncypt,
                    onChanged: (e){
                      setState(() {
                        isEncypt = e;
                      });
                    },

                  ),
                ),
                const SizedBox(
                  width: 80,
                  height: 30,
                  child:
                  Text("是否加密"),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      doCryptMethod();
                    },
                    child:
                    const Text(
                        "解析"
                    ),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  doCryptMethod() async{
    if(isEncypt){
      if(decryptController.text.isEmpty){
        showToast("明文不能为空", context: thisContext);
        return;
      }
      final strEn = await SM4CryptVM.encryptSM4WithString(decryptController.text);
      setState(() {
        encryptController.text = strEn;
      });
    }else{
      if(encryptController.text.isEmpty){
        showToast("密文不能为空", context: thisContext);
        return;
      }
      final strEn = await SM4CryptVM.decryptSM4WithString(encryptController.text);
      setState(() {
        decryptController.text = strEn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Object title = ModalRoute.of(context)?.settings.arguments ?? Object();
    thisContext = context;
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
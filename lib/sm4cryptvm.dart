
import 'package:sm_crypto/sm_crypto.dart';
import 'package:dart_sm/dart_sm.dart' as SM;

class SM4CryptVM {
  static const String iv = "e97200b545feba13";
  static const String key = "0ffb8344490186b7";

  static Future<String> decryptSM4WithString(String text) async{
     var decode = "";
     decode = SM4.decrypt(
       data: text,
       key: SM4.createHexKey(key: key),
       mode: SM4CryptoMode.CBC,
       iv: SM4.createHexKey(key: iv),
     );
     return decode;
  }

  static Future<String> encryptSM4WithString(String text) async{
    var decode = "";
    decode = SM4.encrypt(
      data: text,
      key: SM4.createHexKey(key: key),
      mode: SM4CryptoMode.CBC,
      iv: SM4.createHexKey(key: iv),
    );

    return decode;
  }

}
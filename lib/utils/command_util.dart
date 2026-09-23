import 'package:process_run/process_run.dart';
import 'package:process_run/shell.dart';

class CommandUtil {
/// 用 BluetoothDevicePairing.exe 配对设备
  static Future<bool> pairDevice(String mac, {String pin = '1234'}) async {
    final exePath = 'C:\\Tools\\BluetoothDevicePairing.exe';
    var shell = Shell();
    try {
      final result = await shell.run(
        '''
        '''
        );
      return result.first.exitCode == 0;
    } on Exception catch (e) {
      print('执行失败: $e');
      return false;
    }
  }

  /// 用 Shell 执行多条命令
  static Future<void> pairViaBtCliTools(String mac) async {
    final shell = Shell(verbose: true);
    await shell.run('''
      btdiscovery -s
      btpair -p1234 -b $mac
      btcom -c -b $mac -s1101
    ''');
  }
}
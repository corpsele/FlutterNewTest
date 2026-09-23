//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_bluetooth_plugin/flutter_bluetooth_plugin_c_api.h>
#include <flutter_classic_bluetooth/flutter_classic_bluetooth_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterBluetoothPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterBluetoothPluginCApi"));
  FlutterClassicBluetoothPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterClassicBluetoothPluginCApi"));
}

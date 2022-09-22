#include "include/openpay_bbva/openpay_bbva_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "openpay_bbva_plugin.h"

void OpenpayBbvaPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  openpay_bbva::OpenpayBbvaPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

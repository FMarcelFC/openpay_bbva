#ifndef FLUTTER_PLUGIN_OPENPAY_BBVA_PLUGIN_H_
#define FLUTTER_PLUGIN_OPENPAY_BBVA_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace openpay_bbva {

class OpenpayBbvaPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  OpenpayBbvaPlugin();

  virtual ~OpenpayBbvaPlugin();

  // Disallow copy and assign.
  OpenpayBbvaPlugin(const OpenpayBbvaPlugin&) = delete;
  OpenpayBbvaPlugin& operator=(const OpenpayBbvaPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace openpay_bbva

#endif  // FLUTTER_PLUGIN_OPENPAY_BBVA_PLUGIN_H_

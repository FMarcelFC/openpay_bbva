import Flutter
import UIKit
import OpenpayKit

public class SwiftOpenpayBBVAPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "openpay_bbva", binaryMessenger: registrar.messenger())
    let instance = SwiftOpenpayBBVAPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    var openpay: Openpay!
    guard let args = call.arguments else {
          return
      }
    let myArgs = args as? [String: Any]
    let MERCHANT_ID = myArgs?["MERCHANT_ID"] as? String
    let API_KEY = myArgs?["PUBLIC_API_KEY"] as? String
    let productionMode = myArgs?["productionMode"] as? Bool
      openpay = Openpay(withMerchantId: MERCHANT_ID ?? "", andApiKey: API_KEY ?? "", isProductionMode: productionMode ?? true, isDebug: !(productionMode ?? true))
    openpay.createDeviceSessionId { sessionId in
          result(sessionId)
      } failureFunction: { error in
          result(error.code)
      }
  }
}

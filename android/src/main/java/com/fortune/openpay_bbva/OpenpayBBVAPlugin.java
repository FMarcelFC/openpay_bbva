package com.fortune.openpay_bbva;

import mx.openpay.android.Openpay;
import mx.openpay.android.OpCountry;

import androidx.annotation.NonNull;
import android.app.Activity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** OpenpayBBVAPlugin */
public class OpenpayBbvaPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "openpay_bbva");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    Openpay openpay = new Openpay(call.argument("MERCHANT_ID"), call.argument("API_KEY"), call.argument("productionMode"));
    
    OpenpayBBVA openpayBBVA = new OpenpayBBVA(openpay);
    if (call.method.equals("getDeviceId")) {
       try {
            String deviceId = openpayBBVA.getDeviceId(this.activity);
            result.success(deviceId);
        } catch (Exception e) {
          result.error("Internal error", e.getMessage(), null);
        }
    } else {
      result.notImplemented();
    }

  }
  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding){
    this.activity = binding.getActivity();
  }
  @Override
  public void onDetachedFromActivity(){
    this.activity = null; }
  @Override
  public void onDetachedFromActivityForConfigChanges(){
    this.activity = null; }
  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding){
    this.activity = binding.getActivity(); }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

}
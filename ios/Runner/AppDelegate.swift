import UIKit
import Flutter
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var replayKitChannel: FlutterMethodChannel! = nil
    var observeTimer: Timer?
    var hasEmittedFirstSample = false;
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        FirebaseApp.configure()
        
        replayKitChannel = FlutterMethodChannel(name: "io.livekit.example.flutter/replaykit-channel",binaryMessenger: controller.binaryMessenger)
        
        replayKitChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping  FlutterResult)  -> Void in
            self.handleReplayKitFromFlutter(result: result, call:call)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func handleReplayKitFromFlutter(result:FlutterResult, call: FlutterMethodCall){
        switch (call.method) {
        case "startReplayKit":
            self.hasEmittedFirstSample = false
            let group=UserDefaults(suiteName: "group.io.livekit.example.flutter")
            group!.set(false, forKey: "closeReplayKitFromNative")
            group!.set(false, forKey: "closeReplayKitFromFlutter")
            self.observeReplayKitStateChanged()
            break
        case "closeReplayKit":
            let group=UserDefaults(suiteName: "group.io.livekit.example.flutter")
            group!.set(true,forKey: "closeReplayKitFromFlutter")
            result(true)
            break
        default:
            return result(FlutterMethodNotImplemented)
        }
    }
    

    func observeReplayKitStateChanged(){
        if (self.observeTimer != nil) {
            return
        }
        
        let group=UserDefaults(suiteName: "group.io.livekit.example.flutter")
        self.observeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let closeReplayKitFromNative=group!.bool(forKey: "closeReplayKitFromNative")
            let hasSampleBroadcast=group!.bool(forKey: "hasSampleBroadcast")
            
            if (closeReplayKitFromNative) {
                self.hasEmittedFirstSample = false
                self.replayKitChannel.invokeMethod("closeReplayKitFromNative", arguments: true)
            } else if (hasSampleBroadcast) {
                if (!self.hasEmittedFirstSample) {
                    self.hasEmittedFirstSample = true
                    self.replayKitChannel.invokeMethod("hasSampleBroadcast", arguments: true)
                }
            }
        }
    }
}
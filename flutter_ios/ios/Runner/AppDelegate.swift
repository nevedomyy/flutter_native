import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        NativeSliderPlugin.register(with: self.registrar(forPlugin: "com.example.NativeSliderPlugin")!)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

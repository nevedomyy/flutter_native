//
//  FLPlugin.swift
//  Runner
//
//  Created by Sergey on 10.12.2023.
//

import Flutter
import UIKit

class NativeSliderPlugin: NSObject, FlutterPlugin {
    private static let viewType = "NativeSlider"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = NativeSliderFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: viewType)
    }
}

private class NativeSliderFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var eventSink: FlutterEventSink?

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
        FlutterEventChannel(name: "com.example.ios_flutter.e", binaryMessenger: messenger).setStreamHandler(self)
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeSliderView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            eventSink: eventSink
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

private class NativeSliderView: NSObject, FlutterPlatformView {
    private let screenWidth = UIScreen.main.bounds.width
    private var messenger: FlutterBinaryMessenger?
    private var eventSink: FlutterEventSink?
    private let slider = UISlider()
    private let label = UILabel()
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        eventSink: FlutterEventSink?
    ) {
        _view = UIView()
        super.init()
        self.messenger = messenger
        self.eventSink = eventSink
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    private func createNativeView(view _view: UIView){
        _view.backgroundColor = .green.withAlphaComponent(0.1)
        let title = UILabel()
        title.text = "IOS Native View"
        title.frame = CGRect(x: 20, y: 20, width: 150, height: 30)
    
        self.slider.value = Float(0)
        self.slider.minimumValue = Float(0)
        self.slider.maximumValue = Float(10)
        self.slider.frame = CGRect(x: 24, y: 70, width: screenWidth/2-30, height: 50)
        self.slider.addTarget(self, action: #selector(onChange), for: .valueChanged)
        
        self.label.text = "\(0.0)"
        self.label.frame = CGRect(x: screenWidth/2, y: 70, width: screenWidth/2, height: 50)
        
        addSubviews(title, self.slider, self.label)

        FlutterMethodChannel(name: "com.example.ios_flutter.m",
                             binaryMessenger: messenger!).setMethodCallHandler{ call, _ in
            if (call.method == "valueChange") {
                let value = (call.arguments as? NSDictionary)?["value"] as? Double
                self.onValueChange(value: value ?? 0)
            }
        }
    }
    
    @objc private func onChange(slider: UISlider){
        eventSink?(slider.value)
        self.label.text = String(format: "%.2f", slider.value)
    }
    
    private func onValueChange(value: Double){
        self.slider.value = Float(value)
        self.label.text = String(format: "%.2f", value)
    }
}

extension NativeSliderFactory: FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

extension NativeSliderView{
    func addSubviews(_ views: UIView...){
        views.forEach({ _view.addSubview($0) })
    }
}

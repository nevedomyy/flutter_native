//
//  ViewController.swift
//  IOSFlutter
//
//  Created by Sergey on 08.12.2023.
//

import UIKit
import Flutter

class ViewController: UIViewController {
    private let screenWidth = UIScreen.main.bounds.width
    private var eventSink: FlutterEventSink?
    private let slider = UISlider()
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        nativePart()
        flutterPart()
    }
    
    private func nativePart(){
        let title = UILabel()
        title.text = "IOS Native App"
        title.frame = CGRect(x: 20, y: 50, width: 150, height: 30)
        
        self.slider.value = Float(0)
        self.slider.minimumValue = Float(0)
        self.slider.maximumValue = Float(10)
        self.slider.frame = CGRect(x: 24, y: 100, width: screenWidth/2-30, height: 50)
        self.slider.addTarget(self, action: #selector(onChange), for: .valueChanged)
        
        self.label.text = "\(0.0)"
        self.label.frame = CGRect(x: screenWidth/2, y: 100, width: screenWidth/2, height: 50)
        
        addSubviews(title, self.slider, self.label)
    }
    
    @objc private func onChange(slider: UISlider){
        eventSink?(slider.value)
        self.label.text = String(format: "%.2f", slider.value)
    }
    
    private func flutterPart(){
        let flutterVC = FlutterViewController(project: nil, nibName: nil, bundle: nil)
        addChild(flutterVC)
        flutterVC.view.frame = CGRect(x: 0, y: 200, width: self.screenWidth, height: 150)
        view.addSubview(flutterVC.view)
        
        FlutterEventChannel(name: "com.example.ios_flutter.e",
                            binaryMessenger: flutterVC.binaryMessenger).setStreamHandler(self)
        
        FlutterMethodChannel(name: "com.example.ios_flutter.m",
                             binaryMessenger: flutterVC.binaryMessenger).setMethodCallHandler{ call, _ in
            if (call.method == "valueChange") {
                let value = (call.arguments as? NSDictionary)?["value"] as? Double
                self.onValueChange(value: value ?? 0)
            }
        }
    }
    
    private func onValueChange(value: Double){
        self.slider.value = Float(value)
        self.label.text = String(format: "%.2f", value)
    }
}

extension ViewController: FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

extension UIViewController{
    func addSubviews(_ views: UIView...){
        views.forEach({ view.addSubview($0) })
    }
}
 

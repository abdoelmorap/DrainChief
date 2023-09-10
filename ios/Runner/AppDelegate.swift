import UIKit
import Flutter
import CallKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var callObserver: CXCallObserver?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        self.window.makeSecure()
        
        if isCallKitSupported() {
            callObserver = CXCallObserver()
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationWillResignActive(
        _ application: UIApplication
    ) {
        self.window.isHidden = true;
    }
    override func applicationDidBecomeActive(
        _ application: UIApplication
    ) {
        self.window.isHidden = false;
    }
    func isCallKitSupported() -> Bool {
        let userLocale = NSLocale.current
        
        guard let regionCode = userLocale.regionCode else { return false }
        
        if regionCode.contains("CN") ||
            regionCode.contains("CHN") {
            return false
        } else {
            return true
        }
    }
    
}



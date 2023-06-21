import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCTsnQMYvepCa1mBh-aYJ6bapBSGN7-NHg")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

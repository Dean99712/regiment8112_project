import UIKit
import Flutter
import FirebaseCore
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//      Use this line for Development
      let providerFactory = AppCheckDebugProviderFactory()
//      Use this line for Production
//      let providerFactory = YourAppCheckProviderFactory()
      
      AppCheck.setAppCheckProviderFactory(providerFactory)
    
      
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//      Use this line for Production
//class YourAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
//  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
//    if #available(iOS 14.0, *) {
//      return AppAttestProvider(app: app)
//    } else {
//      return DeviceCheckProvider(app: app)
//    }
//  }
//}

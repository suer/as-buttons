import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        MagicalRecord.setupCoreDataStackWithStoreNamed("as-buttons.sqlite3")
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window!.addSubview(navigationController.view)
        window!.rootViewController = navigationController
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }
}


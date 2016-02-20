import UIKit
import MagicalRecord
import AsakusaSatellite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        MagicalRecord.setupCoreDataStackWithStoreNamed("as-buttons.sqlite3")
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        ColorTheme.setupStyle()
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

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {

        guard let identifier = identifier else {
            completionHandler()
            return
        }

        guard let button = Button.findByUUID(identifier) else {
            completionHandler()
            return
        }

        guard identifier == "POST" else {
            completionHandler()
            return
        }

        AsakusaSatellite.client.postMessage(button.message, roomID: AsakusaSatellite.RoomID, files: []) { r in
            completionHandler()
        }
    }
}


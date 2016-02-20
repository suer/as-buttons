import Foundation
import CoreLocation
import UIKit

class EditViewModel: NSObject, CLLocationManagerDelegate {

    let button: Button

    lazy var locationManager: CLLocationManager = { [unowned self] in
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()

    override init() {
        self.button = Button.newEntity("")
    }

    init(button: Button) {
        self.button = button
    }

    func save() {
        Button.save()
        registerRegion()
    }

    func rollback() {
        Button.rollback()
    }

    var message: String {
        get {
            return button.message
        }
        set {
            button.message = newValue
        }
    }

    var location: CLLocationCoordinate2D? {
        get {
            if button.notificationEnabled {
                return CLLocationCoordinate2D(latitude: button.latitude.doubleValue, longitude: button.longitude.doubleValue)
            }
            return nil
        }
        set {
            if let newValue = newValue {
                button.notificationEnabled = true
                button.latitude = NSDecimalNumber(double: newValue.latitude)
                button.longitude = NSDecimalNumber(double: newValue.longitude)
            }
        }
    }

    var isLocationEmpty: Bool {
        get {
            return button.longitude == 0.0
        }
    }

    var notificationTiming: NotificationTiming {
        get {
            return NotificationTiming.fromInt(button.notificationTiming.integerValue)
        }
        set {
            button.notificationTiming = newValue.rawValue
        }
    }

    // MARK: CLLocationManagerDelegate

    private func registerRegion() {
        guard let l = location else { return }

        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude), radius: 50, identifier: button.uuid)

        for r in locationManager.monitoredRegions {
            if r.identifier == button.uuid {
                locationManager.stopMonitoringForRegion(region)
            }
        }
        locationManager.startMonitoringForRegion(region)
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let button = Button.findByUUID(region.identifier) else { return }
        if button.notificationTiming == NotificationTiming.OnEnter.rawValue {
            notify(button)
        }
    }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let button = Button.findByUUID(region.identifier) else { return }
        if button.notificationTiming == NotificationTiming.OnExit.rawValue {
            notify(button)
        }
    }

    func notify(button: Button) {
        let postAction = UIMutableUserNotificationAction()
        postAction.identifier = "POST"
        postAction.title = "Post"
        postAction.activationMode = .Background
        postAction.authenticationRequired = false

        let category = UIMutableUserNotificationCategory()
        category.identifier = "CREATE_MESSAGE"
        category.setActions([postAction], forContext: .Default)

        let app = UIApplication.sharedApplication();
        app.cancelAllLocalNotifications()
        app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: [category]))

        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5);
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = button.message
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        app.scheduleLocalNotification(notification)
    }
}
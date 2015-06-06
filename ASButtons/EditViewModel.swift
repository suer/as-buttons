import Foundation
import CoreLocation

class EditViewModel: NSObject {

    let button: Button

    override init() {
        self.button = Button.newEntity("")
    }

    init(button: Button) {
        self.button = button
    }

    func save() {
        Button.save()
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

    var location: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: button.latitude.doubleValue, longitude: button.longitude.doubleValue)
        }
        set {
            button.latitude = NSDecimalNumber(double: newValue.latitude)
            button.longitude = NSDecimalNumber(double: newValue.longitude)
        }
    }

    var isLocationEmpty: Bool {
        get {
            return button.longitude == 0.0
        }
    }
}
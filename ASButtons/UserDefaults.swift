import Foundation

class UserDefaults {
    class var keyAPIKey: String { return "apiKey" }

    class var apiKey: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(keyAPIKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: keyAPIKey)
        }
    }
}

import Foundation
import AsakusaSatellite

class AsakusaSatellite {
    class var URL: String? {
        get { return getValue("AsakusaSatelliteURL") }
    }

    class var RoomID: String {
        get { return getValue("RoomID") ?? "" }
    }

    private class func getValue(key: String) -> String? {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("preference", ofType: "plist")
        if let dictionary = NSDictionary(contentsOfFile: path!), url = dictionary.objectForKey(key) as? String {
            return url
        }
        return nil
    }

    class var client: Client {
        get {
            if let url = URL {
                return Client(rootURL: url, apiKey: UserDefaults.apiKey)
            } else {
                return Client(apiKey: UserDefaults.apiKey)
            }
        }
    }
}
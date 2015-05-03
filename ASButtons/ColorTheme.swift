import UIKit

class ColorTheme {
    private class var asakusaSatellite: UIColor { return RGB(200, 2, 2) }
    private class var white: UIColor { return RGB(255, 255, 255) }
    class func setupStyle() {
        UINavigationBar.appearance().barTintColor = asakusaSatellite
        UINavigationBar.appearance().tintColor = white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: white
        ]
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }

    private class func RGB(r: UInt8, _ g: UInt8, _ b: UInt8) -> UIColor {
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 255/255)
    }
}
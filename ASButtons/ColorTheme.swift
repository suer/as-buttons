import UIKit

class ColorTheme {
    class var asakusaSatellite: UIColor { return RGB(200, 2, 2) }
    class var asakusaSatelliteAlpha: UIColor { return RGBA(200, 2, 2, 128) }
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
        return RGBA(r, g, b, 255)
    }

    private class func RGBA(r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8) -> UIColor {
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
}
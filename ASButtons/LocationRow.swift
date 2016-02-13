import Eureka
import MapKit
import Foundation
import UIKit

public final class LocationRow : SelectorRow<CLLocation, MapViewController>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
                return MapViewController(){ _ in }
            },
            completionCallback: { vc in
                vc.navigationController?.popViewControllerAnimated(true)
                guard let mvc = vc as? MapViewController else { return }
                self.title = self.formatCoordinate(mvc.mapView.centerCoordinate)
            }
        )
        displayValueFor = {
            guard let location = $0 else { return "" }
            return  self.formatCoordinate(location.coordinate)
        }
    }

    private func formatCoordinate(coordinate: CLLocationCoordinate2D) -> String {
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 4
        fmt.minimumFractionDigits = 4
        let latitude = fmt.stringFromNumber(coordinate.latitude)!
        let longitude = fmt.stringFromNumber(coordinate.longitude)!
        return  "\(latitude), \(longitude)"
    }
}

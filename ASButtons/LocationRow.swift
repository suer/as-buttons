import Eureka
import MapKit
import Foundation
import UIKit

public final class LocationRow : SelectorRow<CLLocation, MapViewController>, RowType {

    required public init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
                return MapViewController(location: self.value){ _ in }
            },
            completionCallback: { vc in
                vc.navigationController?.popViewControllerAnimated(true)
                guard let mvc = vc as? MapViewController else { return }
                if mvc.mapView.annotations.isEmpty { return }
                let annotation = mvc.mapView.annotations[0]
                self.value = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
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

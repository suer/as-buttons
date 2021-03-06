import UIKit
import Eureka
import MapKit

public class MapViewController : UIViewController, TypedRowControllerType, MKMapViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    public var row: RowOf<CLLocation>!
    public var completionCallback : ((UIViewController) -> ())?
    public var location: CLLocationCoordinate2D!

    lazy var mapView : MKMapView = { [unowned self] in
        let v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        return v
    }()
    
    lazy var pinView: UIImageView = { [unowned self] in
        let v = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        v.image = UIImage(named: "map_pin", inBundle: NSBundle(forClass: MapViewController.self), compatibleWithTraitCollection: nil)
        v.image = v.image?.imageWithRenderingMode(.AlwaysTemplate)
        v.tintColor = self.view.tintColor
        v.backgroundColor = .clearColor()
        v.clipsToBounds = true
        v.contentMode = .ScaleAspectFit
        v.userInteractionEnabled = false
        return v
    }()

    lazy var searchBar: UISearchBar = { [unowned self] in
        let v = UISearchBar()
        v.delegate = self
        v.showsCancelButton = true
        v.showsBookmarkButton = false
        v.showsScopeBar = false
        v.searchBarStyle = .Default
        v.placeholder = "Input keyword"
        return v
    }()

    lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
        let g = UITapGestureRecognizer()
        return g
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience public init(location: CLLocation?, _ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
        guard let coordinate = location?.coordinate else { return }
        self.location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)

        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false

        mapView.delegate = self
        mapView.addSubview(pinView)

        tapGesture.addTarget(self, action: "mapViewDidTap")
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
        searchBar.frame = CGRectMake(0, 0, view.bounds.width, 40)
        view.addSubview(searchBar)

        if let location = self.location {
            resetAnnotations(location)
        }

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
        
        if let value = row.value {
            let region = MKCoordinateRegionMakeWithDistance(value.coordinate, 400, 400)
            mapView.setRegion(region, animated: true)
        } else {
            mapView.showsUserLocation = true
        }
        updateTitle()
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = mapView.convertCoordinate(mapView.centerCoordinate, toPointToView: pinView)
        pinView.center = CGPointMake(center.x, center.y - (CGRectGetHeight(pinView.bounds)/2))
    }
    
    
    func tappedDone(sender: UIBarButtonItem){
        if mapView.annotations.isEmpty { return }
        let coordinate = mapView.annotations[0].coordinate
        row.value? = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        completionCallback?(self)
    }
    
    func updateTitle(){
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 4
        fmt.minimumFractionDigits = 4
        let latitude = fmt.stringFromNumber(mapView.centerCoordinate.latitude)!
        let longitude = fmt.stringFromNumber(mapView.centerCoordinate.longitude)!
        title = "\(latitude), \(longitude)"
    }
    
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        pinAnnotationView.pinColor = MKPinAnnotationColor.Red
        pinAnnotationView.draggable = false
        pinAnnotationView.animatesDrop = true
        return pinAnnotationView
    }
    
    public func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            self?.pinView.center = CGPointMake(self!.pinView.center.x, self!.pinView.center.y - 10)
            })
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            self?.pinView.center = CGPointMake(self!.pinView.center.x, self!.pinView.center.y + 10)
            })
        updateTitle()
    }

    public func mapViewDidTap() {
        if tapGesture.state == .Ended {

            let tapPoint = tapGesture.locationInView(view)
            let center = mapView.convertPoint(tapPoint, toCoordinateFromView: mapView)
            resetAnnotations(center)
        }
    }

    private func resetAnnotations(location: CLLocationCoordinate2D) {
        let circle = MKCircle(centerCoordinate: location, radius: 50)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(circle)

        mapView.removeAnnotations(mapView.annotations)

        let point = MKPointAnnotation()
        point.coordinate = location
        mapView.addAnnotation(point)
        mapView.showAnnotations([point], animated: true)
    }

    public func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = ColorTheme.asakusaSatellite
        circle.fillColor = ColorTheme.asakusaSatelliteAlpha
        circle.lineWidth = 1
        return circle
    }

    // MARK: UISearchBarDelegate

    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, error in
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)

            for item in response?.mapItems ?? [] {
                let point = MKPointAnnotation()
                point.coordinate = item.placemark.coordinate
                point.title = item.placemark.name
                point.subtitle = item.placemark.title
                self.mapView.addAnnotation(point)
            }
            if !self.mapView.annotations.isEmpty {
                self.mapView.setCenterCoordinate(self.mapView.annotations[0].coordinate, animated: true)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }
}

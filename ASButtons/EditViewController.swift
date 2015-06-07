import UIKit
import CoreLocation
import MapKit

class EditViewController: UIViewController, CLLocationManagerDelegate {
    private let textField = UITextField()
    private var mapView: MKMapView!
    private var pin: MKPointAnnotation!
    private var locationManager: CLLocationManager!
    private let editViewModel: EditViewModel
    private var tapGesture: UITapGestureRecognizer!

    convenience init() {
        self.init(editViewModel: EditViewModel())
    }

    init(editViewModel: EditViewModel) {
        self.editViewModel = editViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = I18n.edit
        edgesForExtendedLayout = .None
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        loadTextField()
        loadMapView()
        loadSaveButton()
        loadCancelButton()
    }

    private func loadTextField() {
        textField.text = editViewModel.message
        textField.placeholder = I18n.message
        view.addSubview(textField)
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        view.addConstraints([
            NSLayoutConstraint(item: textField, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(item: textField, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -20.0),
            NSLayoutConstraint(item: textField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: textField, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 50.0)
            ])

        textField.addTarget(self, action: Selector("messageChanged"), forControlEvents: .EditingChanged)
    }

    func messageChanged() {
        editViewModel.message = textField.text
    }

    // MARK: map view

    private func loadMapView() {
        mapView = MKMapView()
        view.addSubview(mapView)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraints([
            NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1.0, constant: view.bounds.width),
            NSLayoutConstraint(item: mapView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: mapView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])

        tapGesture = UITapGestureRecognizer(target: self, action: Selector("mapTapped"))
        mapView.addGestureRecognizer(tapGesture)

        if !editViewModel.isLocationEmpty {
            setLocation(editViewModel.location)
        }

        let currentLocationButton = UIButton()
        currentLocationButton.setTitle("Current Location", forState: .Normal)
        currentLocationButton.setTitleColor(ColorTheme.asakusaSatellite, forState: .Normal)
        view.addSubview(currentLocationButton)
        currentLocationButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraints([
            NSLayoutConstraint(item: currentLocationButton, attribute: .Top, relatedBy: .Equal, toItem: mapView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: currentLocationButton, attribute: .Bottom, relatedBy: .Equal, toItem: mapView, attribute: .Bottom, multiplier: 1.0, constant: 50.0),
            NSLayoutConstraint(item: currentLocationButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: currentLocationButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            ])
        currentLocationButton.addTarget(self, action: Selector("currentLocationButtonTapped"), forControlEvents: .TouchUpInside)
    }

    func mapTapped() {
        let point = tapGesture.locationInView(mapView)
        let coordinate = mapView.convertPoint(point, toCoordinateFromView: mapView)
        setLocation(coordinate)
    }

    func currentLocationButtonTapped() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100

        locationManager.startUpdatingLocation()
    }

    private func setLocation(coordinate: CLLocationCoordinate2D) {
        mapView.setCenterCoordinate(coordinate, animated: true)
        var region = mapView.region
        region.center = coordinate
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region, animated: true)

        mapView.removeAnnotation(pin)
        pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)

        editViewModel.location = coordinate
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100

        locationManager.startUpdatingLocation()
    }

    // MARK: save button
    private func loadSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: I18n.save, style: .Plain, target: self, action: Selector("saveButtonTapped"))
    }

    func saveButtonTapped() {
        editViewModel.save()
        let region = CLCircularRegion(center: editViewModel.location, radius: 50, identifier: editViewModel.button.message)
        setupLocationManager()
        locationManager.startMonitoringForRegion(region)
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: cancel button
    func loadCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: I18n.cancel, style: .Plain, target: self, action: Selector("cancelButtonTapped"))
    }

    func cancelButtonTapped() {
        editViewModel.rollback()
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        setLocation(manager.location.coordinate)
        locationManager.stopUpdatingLocation()
    }
}
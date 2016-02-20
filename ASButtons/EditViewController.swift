import UIKit
import MapKit
import Eureka

class EditViewController: FormViewController {
    private let editViewModel: EditViewModel

    convenience init() {
        self.init(editViewModel: EditViewModel())
    }

    init(editViewModel: EditViewModel) {
        self.editViewModel = editViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = I18n.edit
        edgesForExtendedLayout = .None
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        loadForm()
        loadSaveButton()
        loadCancelButton()
    }
    
    // MARK: form
    
    private func loadForm() {
        form +++ Section()
            <<< TextRow("message") {
                $0.title = "Message"
                $0.placeholder = "Hello"
                $0.value = editViewModel.message
            }.onChange { [weak self] row in
                guard let value = (row.value as String?) else { return }
                self?.editViewModel.message = value
            }
            <<< LocationRow("location") {
                $0.title = "Location"
                $0.value = CLLocation(latitude: editViewModel.location.latitude, longitude: editViewModel.location.longitude)
            }.onChange { [weak self] row in
                guard let location = row.value else { return }
                self?.editViewModel.location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            <<< ChoiceListPopoverSelectorRow<NotificationTiming>("notification timing") {
                $0.title = "Timing of notification"
                $0.selectorTitle = "Timing of notification"
                $0.options = [.OnEnter, .OnExit]
                $0.value = editViewModel.notificationTiming
            }.onChange { [weak self] row in
                guard let notificationTiming = (row.value as NotificationTiming?) else { return }
                self?.editViewModel.notificationTiming = NotificationTiming.fromInt(notificationTiming.value)
            }
    }

    // MARK: save button
    private func loadSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: I18n.save, style: .Plain, target: self, action: Selector("saveButtonTapped"))
    }

    func saveButtonTapped() {
        editViewModel.save()
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
}
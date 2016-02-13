import UIKit
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
            }
            <<< LocationRow("location") {
                $0.title = "Location"
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
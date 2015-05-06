import UIKit
class EditViewController: UIViewController {
    let textField = UITextField()
    let editViewModel: EditViewModel

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
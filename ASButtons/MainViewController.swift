import UIKit

class MainViewController: UITableViewController {

    let buttonsViewModel = ButtonsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.toolbarHidden = false
        self.addObserver(self, forKeyPath: "editing", options: .New, context: nil)
        loadToolBarButtons()
        loadEditButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonsViewModel.fetch()
        tableView.reloadData()
    }

    // MARK: tool bar

    private func loadToolBarButtons() {
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonTapped"))
        toolbarItems = [spacer, addButton]
    }

    func addButtonTapped() {
        let controller = EditViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: edit button

    private func loadEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: Selector("editButtonTapped"))
    }

    func editButtonTapped() {
        editing = !editing
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case "editing":
            navigationItem.rightBarButtonItem?.title = editing ? "Finish" : "Edit"
        default:
            break
        }
    }

    // MARK: table view

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonsViewModel.buttons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = buttonsViewModel.buttons[indexPath.row].message
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let editViewModel = EditViewModel(button: buttonsViewModel.buttons[indexPath.row])
        let controller = EditViewController(editViewModel: editViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            buttonsViewModel.remove(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

}


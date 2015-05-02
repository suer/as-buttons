import UIKit
import AsakusaSatellite

class MainViewController: UITableViewController {

    let buttonsViewModel = ButtonsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.toolbarHidden = false
        self.addObserver(self, forKeyPath: "editing", options: .New, context: nil)
        loadToolBarButtons()
        loadEditButton()
        loadSigninButton()
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

    private func loadSigninButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Signin", style: .Plain, target: self, action: Selector("signinButtonTapped"))
    }

    // MARK: signin button

    func signinButtonTapped() {
        let twitterAuthViewController = TwitterAuthViewController(rootURL: NSURL(string: AsakusaSatellite.client.rootURL)!) {
            apiKey in
            UserDefaults.apiKey = apiKey
        }
        navigationController?.pushViewController(twitterAuthViewController, animated: true)
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
        let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        let editAction = UIAlertAction(title: "Edit", style: .Default) {
            _ in
            let editViewModel = EditViewModel(button: self.buttonsViewModel.buttons[indexPath.row])
            let controller = EditViewController(editViewModel: editViewModel)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        alert.addAction(editAction)
        let postAction = UIAlertAction(title: "Post", style: .Default) {
            _ in
            let message = self.buttonsViewModel.buttons[indexPath.row].message
            AsakusaSatellite.client.postMessage(message, roomID: AsakusaSatellite.RoomID, files: []) { r in
                switch r {
                case .Success(let postMessage):
                    println(postMessage)
                case .Failure(let error):
                    println(error)
                }
                return
            }
            return
        }
        alert.addAction(postAction)
        presentViewController(alert, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            buttonsViewModel.remove(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        buttonsViewModel.move(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
}


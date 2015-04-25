import UIKit

class MainViewController: UITableViewController {

    let buttonsViewModel = ButtonsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        buttonsViewModel.fetch()
        loadBarButtons()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func loadBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonTapped"))
    }

    func addButtonTapped() {
        let controller = EditViewController()
        navigationController?.pushViewController(controller, animated: true)
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
}


import UIKit
import Eureka

class ChoicelistViewController<T: Choice>: UITableViewController, TypedRowControllerType {

    var row: RowOf<T>!
    var completionCallback : ((UIViewController) -> ())?


    var options: [T]!

    init(options: [T]?, _ callback: (UIViewController) -> ()){
        self.options = options
        self.completionCallback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewController

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row].displayValue
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        row.value = options[indexPath.row]
        completionCallback?(self)
    }
}
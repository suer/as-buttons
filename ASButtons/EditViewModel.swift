import Foundation
class EditViewModel: NSObject {

    let button: Button

    override init() {
        self.button = Button.MR_createEntity() as! Button
        self.button.message = ""
    }

    init(button: Button) {
        self.button = button
    }

    func save() {
        Button.save()
    }

    func rollback() {
        Button.rollback()
    }

    var message: String {
        get {
            return button.message
        }
        set {
            button.message = newValue
        }
    }
}
import Foundation
class EditViewModel: NSObject {
    dynamic var message = ""

    func save() {
        let button = Button.MR_createEntity() as! Button
        button.message = message
        Button.save()
    }
}
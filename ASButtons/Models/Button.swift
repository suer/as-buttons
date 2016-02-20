import Foundation
import CoreData
import MagicalRecord

@objc(Button)
class Button: NSManagedObject {

    @NSManaged var uuid: String
    @NSManaged var message: String
    @NSManaged var sort: NSNumber
    @NSManaged var notificationEnabled: Bool
    @NSManaged var latitude: NSDecimalNumber
    @NSManaged var longitude: NSDecimalNumber
    @NSManaged var radius: NSDecimalNumber
    @NSManaged var notificationTiming: NSNumber

    class func newEntity(message: String) -> Button {
        let uuid = NSUUID().UUIDString

        guard let button = MR_createEntity() as Button? else {
            let b = Button()
            b.uuid = uuid
            return b
        }

        button.uuid = uuid

        guard let maxSort = MR_aggregateOperation("max:", onAttribute: "sort", withPredicate: NSPredicate(value: true))?.integerValue else {
            return button
        }

        button.message = message
        button.sort = maxSort
        return button
    }

    class func findByUUID(uuid: String) -> Button? {
        guard let buttons = Button.MR_findByAttribute("uuid", withValue: uuid) as? [Button] else { return nil }
        if buttons.isEmpty {
            return nil
        }
        return buttons[0]
    }

    class func save() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    class func rollback() {
        NSManagedObjectContext.MR_defaultContext().rollback()
    }

    func delete() {
        self.MR_deleteEntity()
        Button.save()
    }

    class func move(fromIndex: Int, toIndex: Int) {
        let buttons = self.MR_findAllSortedBy("sort", ascending: true) as! [Button]
        buttons[fromIndex].sort = toIndex
        if (fromIndex < toIndex) {
            for var i = fromIndex + 1; i <= toIndex; i++ {
                buttons[i].sort = Int(buttons[i].sort) - 1
            }
        } else {
            for var i = toIndex; i < fromIndex; i++ {
                buttons[i].sort = Int(buttons[i].sort) + 1
            }
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
}

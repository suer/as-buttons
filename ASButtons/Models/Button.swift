import Foundation
import CoreData
import MagicalRecord

@objc(Button)
class Button: NSManagedObject {

    @NSManaged var message: String
    @NSManaged var sort: NSNumber
    
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

import Foundation
import CoreData

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
}

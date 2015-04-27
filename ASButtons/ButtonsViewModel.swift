class ButtonsViewModel: NSObject {
    var buttons = [Button]()

    func fetch() {
        buttons = Button.MR_findAllSortedBy("sort", ascending: true) as! [Button]
    }

    func remove(index: Int) {
        buttons[index].delete()
        buttons.removeAtIndex(index)
    }
}
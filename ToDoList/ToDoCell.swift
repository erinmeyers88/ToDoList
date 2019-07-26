import UIKit

@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    var delegate: ToDoCellDelegate?
}


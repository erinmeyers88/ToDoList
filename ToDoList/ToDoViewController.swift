import UIKit
import MessageUI

class ToDoViewController : UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var emailButton: UIButton!
    
    var datePickerHidden = true
    var todo: ToDo?
   
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveAndEmailButtonsState()
    }
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
    isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60) //24 hours from now
        }
        
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveAndEmailButtonsState()
    }
    
    func updateSaveAndEmailButtonsState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        emailButton.isEnabled = !text.isEmpty
    }

    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        switch(indexPath) {
        case [1,0]: //Due Date Cell
            return datePickerHidden ? normalCellHeight : largeCellHeight
        case [2, 0]: //Notes Cell
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath) {
        case [1,0]:
            datePickerHidden = !datePickerHidden
            dueDateLabel.textColor = datePickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        default: break
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)

    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {return}
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        if let todo = todo {
        mailComposer.setSubject(todo.title)
            if let notes = todo.notes {
                 mailComposer.setMessageBody(notes, isHTML: false)
            }
        }
        present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:
        MFMailComposeViewController, didFinishWith result:
        MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

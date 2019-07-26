import UIKit

class ToDoTableViewController : UITableViewController, ToDoCellDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
            displayedTodos = savedToDos
        }
        navigationItem.leftBarButtonItem = editButtonItem
        searchBar.delegate = self
    }

    var todos = [ToDo]()
    var displayedTodos = [ToDo]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedTodos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
            fatalError("Could not dequeue a cell")
        }
        
        let todo = displayedTodos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            for (index, todo) in todos.enumerated() {
                if (todo == displayedTodos[indexPath.row]){
                    todos.remove(at: index)
                }
            }
            ToDo.saveToDos(todos)
             displayedTodos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            
        }
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {return}
        
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                for (index, todoFromList) in todos.enumerated() {
                    if (todoFromList == displayedTodos[selectedIndexPath.row]){
                        todos[index] = todo
                    }
                }
                displayedTodos[selectedIndexPath.row] = todo
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: displayedTodos.count, section: 0)
                todos.append(todo)
                displayedTodos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = displayedTodos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = displayedTodos[indexPath.row]
            todo.isComplete = !todo.isComplete
            displayedTodos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            for (index, todo) in todos.enumerated() {
                if (todo == displayedTodos[indexPath.row]){
                    todos[index].isComplete = !todos[index].isComplete
                }
            }
            
            ToDo.saveToDos(todos)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredTodos = [ToDo]()
        for todo in todos {
            if (searchText == "" || todo.title.uppercased().contains(searchText.uppercased())) {
                filteredTodos.append(todo)
            }
        }
        
        displayedTodos = filteredTodos
        tableView.reloadData()
        
    }
    
}

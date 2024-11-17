import UIKit
//отвечает за отражение списка задач


class TaskListViewController: UITableViewController, UITextViewDelegate, UISearchBarDelegate {
    //сюда нужно как то закинуть api
    var tasks: [ToDo] = [
        ToDo(id: 1, title: "Task1", description: "Описание задачи 1", createdDate: Date(), isCompleted: false)
    ]
    var filteredTasks: [ToDo] = []
    var isSearching = false
    let searchBar = UISearchBar()
    
    private let taskCountLabel = UILabel()
    private let addButton = UIButton(type: .system)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchBar
    }
    
    


    func updateTextLabel() {
        switch tasks.count {
        case 0:
            taskCountLabel.text = String(tasks.count) + "Задач"
        case 1:
            taskCountLabel.text = String(tasks.count) + "Задача"
        case 2...4:
            taskCountLabel.text = String(tasks.count) + "Задачи"
        case 5...:
            taskCountLabel.text = String(tasks.count) + "Задач"
        default:
            taskCountLabel.text = "Количество задач" + String(tasks.count)
        }

    }
    
    

     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchText.isEmpty {
             isSearching = false
             filteredTasks = []
         }
        filteredTasks = tasks.filter { task in
            
            return task.title.lowercased().contains(searchText.lowercased())
        }
         
        isSearching = !searchText.isEmpty
        tableView.reloadData() //перезагружаю таблицу
        
    }
    
    private func setupNavigationBar() {
        //работа с заголовком
        title = "Задачи" //заголовок экрана
        let fontName = "Apple SD Gothic Neo Bold" //шрифт заголовка
        navigationController?.navigationBar.prefersLargeTitles = true // большой заголовок
        
        
        //работаю с навигационной панелью navBarApperarance
        let navBarApperarance = UINavigationBarAppearance() //экземпляр класса для настройки внешнего вида навигационной панели
        
        navBarApperarance.titleTextAttributes = [ //шрифт и цвет для обычного заголовка
            .font: UIFont(name: fontName, size: 19) ?? UIFont.systemFont(ofSize: 19),
            .foregroundColor: UIColor.white
        ]
        
        navBarApperarance.largeTitleTextAttributes = [ //шрифт и цвет для большого заголовка
            .font: UIFont(name: fontName, size: 35) ?? UIFont.systemFont(ofSize: 35),
            .foregroundColor: UIColor.white
        ]
        
        navBarApperarance.backgroundColor = UIColor ( //цвет для навигационной панели
            red: 100/255,
            green: 100/255,
            blue: 100/255,
            alpha: 100/255
        )
        navigationController?.navigationBar.standardAppearance = navBarApperarance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperarance
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton

    }
    
        @objc private func addTask() {
            let detailViewController = DetailViewController()
           
            var newTask = ToDo(id: tasks.count + 1, title: "Новая Заметка", description:"Описание задачи ", createdDate: Date(), isCompleted: false)
            
            detailViewController.task = newTask
            detailViewController.title = "Создание новой задачи"
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    

    
    
    
    
    
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
    //эта функция мб потом понадобится
//        return 20 // Один раздел в таблице //нужно будет сюда добавить динамическое добавление ячеек tasks
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTasks.count : tasks.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row] // Получаем задачу в зависимости от режима
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard tasks.indices.contains(indexPath.row) else {
            printContent("Selected index is out of bounds")
            return
        }
        let selectedTask = tasks[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.task = selectedTask
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }

    
}

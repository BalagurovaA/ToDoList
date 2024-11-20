import UIKit

class TaskListViewController: UITableViewController, UITextViewDelegate, UISearchBarDelegate, DetailViewControllerDelegate {
    
    
    var tasks: [ToDo] = []
    var filteredTasks: [ToDo] = []
    var isSearching = false
    let searchBar = UISearchBar()
    

    private let taskCountLabel = UILabel()
    private let addButton = UIButton(type: .system)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    
    }

    private func setUpUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")

        tableView.backgroundColor = UIColor.black
        setupNavigationBar()
        setupSearchBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    

    private func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.barTintColor = UIColor.black
        searchBar.backgroundColor = UIColor.black
        searchBar.searchTextField.backgroundColor = UIColor.darkGray
        searchBar.searchTextField.textColor = UIColor.white// Цвет текста
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.lightGray])

        tableView.tableHeaderView = searchBar
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
        let fontName = "Apple SD Gothic Neo Bold" //шрифт заголовка
        let navBarApperarance = UINavigationBarAppearance()
        
        navBarApperarance.titleTextAttributes = [ //шрифт и цвет для обычного заголовка
            .font: UIFont(name: fontName, size: 35)?.withTraits(traits: .traitBold) ?? UIFont.systemFont(ofSize: 45, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        navBarApperarance.largeTitleTextAttributes = [ //шрифт и цвет для большого заголовка
            .font: UIFont(name: fontName, size: 35)?.withTraits(traits: .traitBold) ?? UIFont.systemFont(ofSize: 45, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        navBarApperarance.backgroundColor = UIColor ( //цвет для навигационной панели
            red: 0/255,
            green: 0/255,
            blue: 0/255,
            alpha: 255/255
        )
        navigationController?.navigationBar.standardAppearance = navBarApperarance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperarance
        
        //заголовок "Задачи"
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont(name: fontName, size: 35)?.withTraits(traits: .traitBold) ?? UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleLabel.center = titleView.center
        titleView.addSubview(titleLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        
        //кнопка для добавления задачи
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        addButton.tintColor = UIColor.yellow
        navigationItem.rightBarButtonItem = addButton
        
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTasks.count : tasks.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row] // Получаем задачу в зависимости от режима


        cell.textLabel?.text = task.title
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        let dateString = DateToString(task.createdDate)
        cell.detailTextLabel?.text = dateString
        cell.detailTextLabel?.textColor = UIColor.lightGray
        return cell
    }

    private func DateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tasks.indices.contains(indexPath.row) else {
            printContent("Selected index is out of bounds")
            return
        }
        let selectedTask = tasks[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.task = selectedTask
    
        detailViewController.isNewTask = false 
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    //функция для перехода на DetalView
    @objc private func addTask() {
        let detailVC = DetailViewController()
        detailVC.delegate = self
        detailVC.isNewTask = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    

    func didAddTask(_ task: ToDo) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            // Если задача уже существует, обновляем её
            tasks[index] = task
        } else {
            // Иначе добавляем новую задачу
            tasks.append(task)
        }

        // Обновляем список отфильтрованных задач, если мы ищем
        if isSearching {
            filteredTasks = tasks.filter { $0.title.lowercased().contains(searchBar.text?.lowercased() ?? "") }
        }
        tableView.reloadData()
    }

}

//расишрение для заголовков
extension UIFont {
 func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
     let descriptor = self.fontDescriptor.withSymbolicTraits(traits)
     if let descriptor = descriptor {
        return UIFont(descriptor: descriptor, size: 0)
  }
      return nil
 }
}






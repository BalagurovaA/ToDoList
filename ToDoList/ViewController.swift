import UIKit
//отвечает за отражение списка задач


class TaskListViewController: UITableViewController, UITextViewDelegate, UISearchBarDelegate, DetailViewControllerDelegate {
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
        
//       чтобы повторно использовать экземпляры ячеек когда они выходят за пределы видимости на экране
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")

        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        setupSearchBar()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
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
        
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont(name: fontName, size: 35)?.withTraits(traits: .traitBold) ?? UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleLabel.center = titleView.center
        titleView.addSubview(titleLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        addButton.tintColor = UIColor.yellow
        navigationItem.rightBarButtonItem = addButton

    }
    

    
        @objc private func addTask() {
            let detailViewController = DetailViewController()
            detailViewController.delegate = self
            detailViewController.isNewTask = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    
    func didAddTask(_ task: ToDo) {
        tasks.append(task)
        tableView.reloadData()
    }
    
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTasks.count : tasks.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row] // Получаем задачу в зависимости от режима
    

        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.description
        

        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white

        
        cell.backgroundColor = UIColor.black
       
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


extension UIFont {
 func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
     let descriptor = self.fontDescriptor.withSymbolicTraits(traits)
     if let descriptor = descriptor {
        return UIFont(descriptor: descriptor, size: 0)
  }
      return nil
 }
}

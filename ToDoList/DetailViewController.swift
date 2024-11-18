import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    var task: ToDo?
    var isNewTask: Bool = false
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad() //вызов метода род класса
        view.backgroundColor = UIColor.black
        setUpTextView()

    }
    
    //функция для работы с текстовым объектом
    private func setUpTextView() {
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.black
        textView.textColor = UIColor.white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 20
        
    
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
      ])
        
        //запуск делегата для сохранения и работы между классами
        textView.delegate = self
        
      func getTitle() -> String {
          let lines = textView.text.split(separator: "\n", omittingEmptySubsequences: true)
          return lines.first.map(String.init) ?? ""
          
      }
}
    
    
    @objc private func addTask() -> Bool {
        let detailViewController = DetailViewController()
//        detailViewController.delegate = self // Устанавливаем делегата
        detailViewController.isNewTask = true
        if ((self.navigationController?.pushViewController(detailViewController, animated: true)) != nil) {
         return true
        }
        return false
    }

    
    
    
    
    @objc private func saveTask() {
        guard let text = textView.text else {
            return
        }
        
        let lines = text.split(separator: "\n")
        let title = lines.first.map(String.init) ?? ""
        let descrip = String(text)
        if isNewTask {
            let newTask = ToDo(
                id: UUID().hashValue,
                title: title,
                description: descrip,
                createdDate: Date(),
                isCompleted: false
            )
        }
        else if var taskToUpdate = task {
            taskToUpdate.title = title
            taskToUpdate.description = descrip
            self.task = taskToUpdate
        }

        navigationController?.popViewController(animated: true) // Возврат на предыдущую страницу
        }
}

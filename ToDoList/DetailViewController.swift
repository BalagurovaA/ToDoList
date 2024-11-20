import UIKit
protocol DetailViewControllerDelegate: AnyObject {
    func didAddTask(_ task: ToDo)
}

class DetailViewController: UIViewController, UITextViewDelegate {
    var delegate: DetailViewControllerDelegate?
    var task: ToDo?
    var isNewTask: Bool = false
    var textView: UITextView!
    var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad() //вызов метода род класса
        view.backgroundColor = UIColor.black
        setUpTextView()
        setUpDateLabel()
        
        
        textView.delegate = self
        if let task = task {
            textView.text = task.description
            title = task.title
            dateLabel.text = DateToString(task.createdDate)
        }
        
    }
    
    
    //функция чтобы дату переделать в sring
    private func DateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
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
    }
    
    private func setUpDateLabel() {
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
    }
    
    
    func WriteIntoTheTask() {
        guard let text = textView.text else {
            return
        }
        
        let lines = text.split(separator: "\n")
        let title = lines.first.map(String.init) ?? ""
        let mainText = String(text)
        if isNewTask {
            let newTask = ToDo(
                id: UUID(),
                title: title,
                description: mainText,
                createdDate: Date(),
                isCompleted: false
            )
         
            delegate?.didAddTask(newTask)
        }
            else if var existingTask = task {
                existingTask.title = title
                existingTask.description = mainText
                existingTask.createdDate = Date()
                delegate?.didAddTask(existingTask)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) { //функция вызывается автоматически
        WriteIntoTheTask()
    }
    
}

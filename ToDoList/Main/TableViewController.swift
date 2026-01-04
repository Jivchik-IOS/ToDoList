import UIKit

class TableViewController: UITableViewController {
    
    private var viewModel = TasksViewModel()
    private var customAlertView: CustomAlertControl?
    
    private lazy var addButton: UIBarButtonItem = {
        $0.tintColor = .systemOrange
        return $0
    }(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)))
    
    private lazy var editButton: UIBarButtonItem = {
        $0.tintColor = .systemOrange
        return $0
    }(UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(editButtonTapped)))
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = {
            $0.image = UIImage(systemName: "checklist")
            $0.tintColor = .systemGray3
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            return $0
        }(UIImageView())
        
        let label = {
            $0.text = "Задач пока нет\nДобавьте первую задачу!"
            $0.textColor = .systemGray
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 18, weight: .medium)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            return $0
        }(UILabel())
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        return view
    }()
    
    // MARK: - WillApp
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Мои задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = addButton
        
        let statsButton = UIBarButtonItem(image: UIImage(systemName: "chart.bar"), style: .plain, target: self, action: #selector(showStatistics))
        statsButton.tintColor = .systemOrange
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let leftButtons = [editButton, flexibleSpace, statsButton]
            navigationItem.leftBarButtonItems = leftButtons
        navigationItem.leftBarButtonItem = editButton
        
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor
        ]
        tableView.backgroundView = UIView()
        tableView.backgroundView?.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    // MARK: - OBJC FUNC
    
    @objc private func showStatistics() {
        let statsViewModel = StatisticsViewModel(tasks: viewModel.toDoItems)
        let statsVC = StatisticsViewController(viewModel: statsViewModel)
        statsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(statsVC, animated: true)
    }
    
    @objc private func addButtonTapped() {
        showCustomAlert()
    }
    
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Готово" : "Изменить"
    }
    
    private func showCustomAlert() {
        customAlertView?.removeFromSuperview()
        customAlertView = CustomAlertControl(frame: view.bounds)
        
        guard let alertView = customAlertView else { return }
        
        alertView.delegate = self
        alertView.taskField.text = ""
        view.addSubview(alertView)
        alertView.showAlert()
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.getTasksCount() == 0
        emptyStateView.isHidden = !isEmpty
        tableView.separatorStyle = isEmpty ? .none : .singleLine
    }
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTasksCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = viewModel.getTask(at: indexPath.row)
        cell.configure(with: task)
        
        return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.changeState(at: indexPath.row)
        
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            let task = viewModel.getTask(at: indexPath.row)
            cell.updateCheckmark(isCompleted: task.isCompleted)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateEmptyState()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return tableView.isEditing ? .none : .delete
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            self?.viewModel.removeItem(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.updateEmptyState()
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - CustomAlertControlDelegate
extension TableViewController: CustomAlertControlDelegate {
    func didAddTask(task: String, difficulty: Difficulty) {
        viewModel.addTask(newItem: task, difficulty: difficulty)
        tableView.reloadData()
        updateEmptyState()
        
        showSuccessAlert(message: "Задача добавлена!")
    }
    
    func didCancel() {
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Успешно!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

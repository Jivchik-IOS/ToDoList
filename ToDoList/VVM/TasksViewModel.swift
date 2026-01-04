import UIKit
final class TasksViewModel: TasksViewModelProtocol {
    
    private let userDefaultsKey = "ToDoItemsData"
    
    var toDoItems: [ConstructorTask] {
        get {
            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
            do {
                return try JSONDecoder().decode([ConstructorTask].self, from: data)
            } catch {
                print("Ошибка при загрузке: \(error)")
                return []
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: userDefaultsKey)
                setBadge()
            } catch {
                print("Ошибка при сохранении: \(error)")
            }
        }
    }
    
    func getTasksCount() -> Int {
        return toDoItems.count
    }
    
    func getTask(at index: Int) -> ConstructorTask {
        guard index >= 0 && index < toDoItems.count else {
            return ConstructorTask(task: "")
        }
        return toDoItems[index]
    }
    
    func addTask(newItem: String, isCompleted: Bool = false, difficulty: Difficulty = .easy) {
        guard !newItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let task = ConstructorTask(task: newItem, isCompleted: isCompleted, difficulty: difficulty)
        toDoItems.append(task)
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < toDoItems.count else { return }
        toDoItems.remove(at: index)
    }
    
    func changeState(at item: Int) -> Bool {
        guard item >= 0 && item < toDoItems.count else { return false }
        toDoItems[item].isCompleted = !toDoItems[item].isCompleted
        return toDoItems[item].isCompleted
    }
    
    func checkDifficulty(at item: Int) -> Difficulty {
        guard item >= 0 && item < toDoItems.count else { return .easy }
        return toDoItems[item].difficulty
    }
    func moveItem(from indexF: Int, to indexT: Int) {
            guard indexF >= 0 && indexF < toDoItems.count,
                  indexT >= 0 && indexT < toDoItems.count else { return }
            let item = toDoItems[indexF]
            toDoItems.remove(at: indexF)
            toDoItems.insert(item, at: indexT)
        }
        
        func requestForNotification() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
                if granted {
                    print("Разрешение на уведомления получено")
                } else {
                    print("Разрешение на уведомления отклонено")
                }
            }
        }
        //MARK: обновление пометки задач
        private func setBadge() {
            let incompleteCount = toDoItems.filter { !$0.isCompleted }.count
            NotificationService.shared.updateBadgeCount(incompleteCount)
        }
    
        func filterTasks(by difficulty: Difficulty?) -> [ConstructorTask] {
            guard let difficulty = difficulty else { return toDoItems }
            return toDoItems.filter { $0.difficulty == difficulty }
        }
        
        func clearCompletedTasks() {
            toDoItems = toDoItems.filter { !$0.isCompleted }
        }
    }


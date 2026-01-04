import Foundation
import UIKit

enum Difficulty: Int, Codable, CaseIterable {
    case easy = 0
    case medium = 1
    case hard = 2
    
    var title: String {
        switch self {
        case .easy: return "Легко"
        case .medium: return "Средне"
        case .hard: return "Трудно"
        }
    }
    
    var color: UIColor {
        switch self {
        case .easy: return .systemGreen
        case .medium: return .systemOrange
        case .hard: return .systemRed
        }
    }
}

struct ConstructorTask: Codable {
    var task: String
    var isCompleted: Bool
    var difficulty: Difficulty
    var creationDate: Date
    var id: UUID
    
    init(task: String, isCompleted: Bool = false, difficulty: Difficulty = .easy) {
        self.task = task
        self.isCompleted = isCompleted
        self.difficulty = difficulty
        self.creationDate = Date()
        self.id = UUID()
    }
}

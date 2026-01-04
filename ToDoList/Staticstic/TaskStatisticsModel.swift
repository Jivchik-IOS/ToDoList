//
//  TaskStatistics.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import Foundation

struct TaskStatisticsModel {
    let totalTasks: Int
    let completedTasks: Int
    let pendingTasks: Int
    let completionRate: Double
    let averageCompletionTime: TimeInterval?
    let tasksByDifficulty: [Difficulty: Int]
    let tasksByDay: [Date: Int]
    
    var easyTasksCount: Int { tasksByDifficulty[.easy] ?? 0 }
    var mediumTasksCount: Int { tasksByDifficulty[.medium] ?? 0 }
    var hardTasksCount: Int { tasksByDifficulty[.hard] ?? 0 }
}

struct ProductivityData {
    let day: String
    let completedCount: Int
    let totalCount: Int
    let productivityScore: Double
}

//
//  StatisticsViewModelProtocol.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import Foundation
import UIKit

protocol StatisticsViewModelProtocol {
    var statistics: TaskStatisticsModel { get }
    var productivityData: [ProductivityData] { get }
    var mostProductiveDay: String? { get }
    var mostCommonDifficulty: Difficulty? { get }
    
    func calculateStatistics(tasks: [ConstructorTask])
    func getChartData() -> [(String, Int)]
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    var statistics: TaskStatisticsModel
    var productivityData: [ProductivityData] = []
    
    init(tasks: [ConstructorTask] = []) {
        self.statistics = TaskStatisticsModel(
            totalTasks: 0,
            completedTasks: 0,
            pendingTasks: 0,
            completionRate: 0,
            averageCompletionTime: nil,
            tasksByDifficulty: [:],
            tasksByDay: [:]
        )
        if !tasks.isEmpty {
            calculateStatistics(tasks: tasks)
        }
    }
    
    func calculateStatistics(tasks: [ConstructorTask]) {
        let completedTasks = tasks.filter { $0.isCompleted }
        let pendingTasks = tasks.filter { !$0.isCompleted }
        
        
        var difficultyDict: [Difficulty: Int] = [:]
        Difficulty.allCases.forEach { difficulty in
            difficultyDict[difficulty] = tasks.filter { $0.difficulty == difficulty }.count
        }
        
        var tasksByDay: [Date: Int] = [:]
        let calendar = Calendar.current
        let today = Date()
        
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let startOfDay = calendar.startOfDay(for: date)
                let tasksOnDay = tasks.filter {
                    calendar.isDate($0.creationDate, inSameDayAs: startOfDay)
                }.count
                tasksByDay[startOfDay] = tasksOnDay
            }
        }
        

        let averageTime: TimeInterval? = {
            guard !completedTasks.isEmpty else { return nil }
            let completionTimes = completedTasks.compactMap { task -> TimeInterval? in
        
                return Double.random(in: 3600...86400)
            }
            return completionTimes.reduce(0, +) / Double(completionTimes.count)
        }()
        

        let completionRate = tasks.isEmpty ? 0 : Double(completedTasks.count) / Double(tasks.count) * 100
        
        statistics = TaskStatisticsModel(
            totalTasks: tasks.count,
            completedTasks: completedTasks.count,
            pendingTasks: pendingTasks.count,
            completionRate: completionRate,
            averageCompletionTime: averageTime,
            tasksByDifficulty: difficultyDict,
            tasksByDay: tasksByDay
        )
        
        calculateProductivityData(tasks: tasks)
    }
    
    private func calculateProductivityData(tasks: [ConstructorTask]) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        
        var data: [ProductivityData] = []
        
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) {
                let startOfDay = calendar.startOfDay(for: date)
                let dayTasks = tasks.filter {
                    calendar.isDate($0.creationDate, inSameDayAs: startOfDay)
                }
                
                let completed = dayTasks.filter { $0.isCompleted }.count
                let total = dayTasks.count
                let score = total == 0 ? 0 : Double(completed) / Double(total) * 100
                
                let dayString = dateFormatter.string(from: date)
                
                data.append(ProductivityData(
                    day: dayString,
                    completedCount: completed,
                    totalCount: total,
                    productivityScore: score
                ))
            }
        }
        
        productivityData = data.reversed() 
    }
    
    var mostProductiveDay: String? {
        guard !productivityData.isEmpty else { return nil }
        return productivityData.max { $0.productivityScore < $1.productivityScore }?.day
    }
    
    var mostCommonDifficulty: Difficulty? {
        let difficulties = statistics.tasksByDifficulty
        return difficulties.max { $0.value < $1.value }?.key
    }
    
    func getChartData() -> [(String, Int)] {
        return [
            ("Легкие", statistics.easyTasksCount),
            ("Средние", statistics.mediumTasksCount),
            ("Сложные", statistics.hardTasksCount)
        ]
    }
}

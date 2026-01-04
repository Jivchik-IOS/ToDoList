//
//  StatisticsViewController.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import UIKit

class StatisticsViewController: UIViewController {
    
    private let progressBar = ProgressBarView()
    private let viewModel: StatisticsViewModel
    private var statCards: [StatCardView] = []
    
    private let scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIScrollView())
    
    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.text = "Статистика продуктивности"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .label
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    private let statsStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIStackView())
    
    private let completionRateView: UIView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private let completionTitleLabel: UILabel = {
        $0.text = "Общий прогресс"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    
    
    private let difficultyChartView: UIView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private let chartTitleLabel: UILabel = {
        $0.text = "Распределение по сложности"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    private let chartStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 12
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIStackView())
    
    // MARK: - Init
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - willApp
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Статистика"
        
        setupNavigationBar()
        setupScrollView()
        setupStatsGrid()
        setupCompletionRateView()
        setupDifficultyChart()
    }
    
    private func setupNavigationBar() {
        let refreshButton = {
            $0.tintColor = .systemOrange
            
            return $0
        }(UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshStatistics)
        ))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(statsStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupStatsGrid() {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 12
        
        let firstRow = createStatsRow()
        gridStackView.addArrangedSubview(firstRow)
        
        let secondRow = createStatsRow()
        gridStackView.addArrangedSubview(secondRow)
        
        statsStackView.addArrangedSubview(gridStackView)
    }
    
    private func createStatsRow() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = 12
        
        for _ in 0..<2 {
            let card = StatCardView()
            card.translatesAutoresizingMaskIntoConstraints = false
            rowStackView.addArrangedSubview(card)
            statCards.append(card)
            
            NSLayoutConstraint.activate([
                card.heightAnchor.constraint(equalToConstant: 120)
            ])
        }
        
        return rowStackView
    }
    
    private func setupCompletionRateView() {
        completionRateView.addSubview(completionTitleLabel)
        completionRateView.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completionTitleLabel.topAnchor.constraint(equalTo: completionRateView.topAnchor, constant: 20),
            completionTitleLabel.leadingAnchor.constraint(equalTo: completionRateView.leadingAnchor, constant: 20),
            completionTitleLabel.trailingAnchor.constraint(equalTo: completionRateView.trailingAnchor, constant: -20),
            
            progressBar.topAnchor.constraint(equalTo: completionTitleLabel.bottomAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: completionRateView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: completionRateView.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 32),
            progressBar.bottomAnchor.constraint(equalTo: completionRateView.bottomAnchor, constant: -20)
        ])
        
        statsStackView.addArrangedSubview(completionRateView)
    }
    
    private func setupDifficultyChart() {
        difficultyChartView.addSubview(chartTitleLabel)
        difficultyChartView.addSubview(chartStackView)
        
        NSLayoutConstraint.activate([
            chartTitleLabel.topAnchor.constraint(equalTo: difficultyChartView.topAnchor, constant: 20),
            chartTitleLabel.leadingAnchor.constraint(equalTo: difficultyChartView.leadingAnchor, constant: 20),
            chartTitleLabel.trailingAnchor.constraint(equalTo: difficultyChartView.trailingAnchor, constant: -20),
            
            chartStackView.topAnchor.constraint(equalTo: chartTitleLabel.bottomAnchor, constant: 20),
            chartStackView.leadingAnchor.constraint(equalTo: difficultyChartView.leadingAnchor, constant: 20),
            chartStackView.trailingAnchor.constraint(equalTo: difficultyChartView.trailingAnchor, constant: -20),
            chartStackView.bottomAnchor.constraint(equalTo: difficultyChartView.bottomAnchor, constant: -20)
        ])
        
        statsStackView.addArrangedSubview(difficultyChartView)
        
        let bottomSpacer = UIView()
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        statsStackView.addArrangedSubview(bottomSpacer)
    }
    
    // MARK: - Update Static
    private func updateStatistics() {
        let stats = viewModel.statistics
        
        updateStatCards(with: stats)
        
        progressBar.progress = CGFloat(stats.completionRate / 100)
        
        updateDifficultyChart()
    }
    
    private func updateStatCards(with stats: TaskStatisticsModel) {
        guard statCards.count >= 4 else { return }
        
        statCards[0].title = "Всего задач"
        statCards[0].value = "\(stats.totalTasks)"
        statCards[0].icon = UIImage(systemName: "checklist")
        statCards[0].valueColor = .systemBlue
        
        statCards[1].title = "Выполнено"
        statCards[1].value = "\(stats.completedTasks)"
        statCards[1].icon = UIImage(systemName: "checkmark.circle.fill")
        statCards[1].valueColor = .systemGreen
        statCards[1].subtitle = "\(Int(stats.completionRate))%"
        
        statCards[2].title = "В процессе"
        statCards[2].value = "\(stats.pendingTasks)"
        statCards[2].icon = UIImage(systemName: "clock.fill")
        statCards[2].valueColor = .systemOrange
        
        if let mostCommon = viewModel.mostCommonDifficulty {
            statCards[3].title = "Частая сложность"
            statCards[3].value = mostCommon.title
            statCards[3].icon = UIImage(systemName: "chart.bar.fill")
            statCards[3].valueColor = mostCommon.color
        } else {
            statCards[3].title = "Нет данных"
            statCards[3].value = "—"
            statCards[3].icon = UIImage(systemName: "chart.bar")
            statCards[3].valueColor = .systemGray
        }
    }
    
    private func updateDifficultyChart() {
        chartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let chartData = viewModel.getChartData()
        let maxValue = chartData.map { $0.1 }.max() ?? 1
        
        for (difficultyName, count) in chartData {
            let row = createChartRow(difficulty: difficultyName, count: count, maxCount: maxValue)
            chartStackView.addArrangedSubview(row)
        }
    }
    
    private func createChartRow(difficulty: String, count: Int, maxCount: Int) -> UIView {
        let rowView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            return $0
        }(UIView())
        
        let nameLabel = {
            $0.text = difficulty
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .secondaryLabel
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            return $0
        }(UILabel())
        
        let countLabel = {
            $0.text = "\(count)"
            $0.font = .systemFont(ofSize: 14, weight: .bold)
            $0.textColor = .label
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            return $0
        }(UILabel())
        
        let barView = {
            $0.backgroundColor = getColorForDifficulty(difficulty)
            $0.layer.cornerRadius = 4
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            return $0
        }(UIView())
        
        rowView.addSubview(nameLabel)
        rowView.addSubview(countLabel)
        rowView.addSubview(barView)
        
        let barWidth = maxCount > 0 ? CGFloat(count) / CGFloat(maxCount) * 200 : 0
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            barView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 12),
            barView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            barView.widthAnchor.constraint(equalToConstant: barWidth),
            barView.heightAnchor.constraint(equalToConstant: 16),
            
            countLabel.leadingAnchor.constraint(equalTo: barView.trailingAnchor, constant: 12),
            countLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            
            rowView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        return rowView
    }
    
    private func getColorForDifficulty(_ difficulty: String) -> UIColor {
        switch difficulty {
        case "Легкие": return .systemGreen
        case "Средние": return .systemOrange
        case "Сложные": return .systemRed
        default: return .systemGray
        }
    }
    
    // MARK: - OBJC FUNC
    @objc private func refreshStatistics() {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 0.7
        }) { _ in
            self.updateStatistics()
            UIView.animate(withDuration: 0.3) {
                self.scrollView.alpha = 1.0
            }
        }
    }
}

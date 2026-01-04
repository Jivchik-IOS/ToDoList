//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "cellName"
    
    private let containerView: UIView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private let checkmarkButton: UIButton = {
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        $0.tintColor = .systemGreen
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIButton())
    
    private let taskLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    private let difficultyView: UIView = {
        $0.layer.cornerRadius = 4
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private let difficultyLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(checkmarkButton)
        containerView.addSubview(taskLabel)
        containerView.addSubview(difficultyView)
        difficultyView.addSubview(difficultyLabel)
    }
    
    
    //MARK: Constr
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            checkmarkButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            checkmarkButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),
            
            taskLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 12),
            taskLabel.trailingAnchor.constraint(equalTo: difficultyView.leadingAnchor, constant: -8),
            taskLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            taskLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            difficultyView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            difficultyView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            difficultyView.widthAnchor.constraint(equalToConstant: 60),
            difficultyView.heightAnchor.constraint(equalToConstant: 24),
            
            difficultyLabel.centerXAnchor.constraint(equalTo: difficultyView.centerXAnchor),
            difficultyLabel.centerYAnchor.constraint(equalTo: difficultyView.centerYAnchor)
        ])
    }
    
    // MARK: - ConfigureConte
    func configure(with task: ConstructorTask) {
        taskLabel.text = task.task
        checkmarkButton.isSelected = task.isCompleted
        
        if task.isCompleted {
            let attributedString = NSAttributedString(
                string: task.task,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                           .foregroundColor: UIColor.secondaryLabel]
            )
            taskLabel.attributedText = attributedString
            containerView.alpha = 0.7
        } else {
            taskLabel.attributedText = NSAttributedString(
                string: task.task,
                attributes: [.foregroundColor: UIColor.label]
            )
            containerView.alpha = 1.0
        }
        
        switch task.difficulty {
        case .easy:
            difficultyView.backgroundColor = .systemGreen
            difficultyLabel.text = "ЛЕГКО"
        case .medium:
            difficultyView.backgroundColor = .systemOrange
            difficultyLabel.text = "СРЕДНЕ"
        case .hard:
            difficultyView.backgroundColor = .systemRed
            difficultyLabel.text = "ТРУДНО"
        }
    }
    
    func updateCheckmark(isCompleted: Bool) {
        checkmarkButton.isSelected = isCompleted
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = isCompleted ? 0.7 : 1.0
        }
    }
}

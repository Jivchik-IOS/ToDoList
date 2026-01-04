//
//  StatCardView.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import UIKit

class StatCardView: UIView {
    
    private let titleLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    private lazy var valueLabel = {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = valueColor
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    private let iconImageView = {
        $0.tintColor = .systemOrange
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIImageView())
    private let subtitleLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .tertiaryLabel
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    var title: String = "" {
        didSet { titleLabel.text = title }
    }
    
    var value: String = "" {
        didSet { valueLabel.text = value }
    }
    
    var icon: UIImage? {
        didSet { iconImageView.image = icon }
    }
    
    var subtitle: String = "" {
        didSet { 
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = subtitle.isEmpty
        }
    }
    
    var valueColor: UIColor = .label {
        didSet { valueLabel.textColor = valueColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        
        addSubview(iconImageView)
        
        addSubview(titleLabel)
        
        addSubview(valueLabel)
        
        addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

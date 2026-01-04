//
//  ProgressBarView.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 03.01.2026.
//


import UIKit

class ProgressBarView: UIView {
    
    private lazy var progressLayer = {
        $0.backgroundColor = barColor.cgColor
        $0.cornerRadius = 8
        
        return $0
    }(CALayer())
    private let backgroundLayer = {
        $0.backgroundColor = UIColor.tertiarySystemBackground.cgColor
        $0.cornerRadius = 8
        
        return $0
    }(CALayer())
    private let percentageLabel = {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .white
        
        return $0
    }(UILabel())
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    var barColor: UIColor = .systemOrange {
        didSet {
            progressLayer.backgroundColor = barColor.cgColor
        }
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
        backgroundColor = .clear
        
        layer.addSublayer(backgroundLayer)
        
        layer.addSublayer(progressLayer)
        
        addSubview(percentageLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        
        let progressWidth = bounds.width * min(progress, 1.0)
        progressLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: progressWidth,
            height: bounds.height
        )
        
        percentageLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: progressWidth,
            height: bounds.height
        )
    }
    
    private func updateProgress() {
        let percentage = Int(progress * 100)
        percentageLabel.text = "\(percentage)%"
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        
        let color: UIColor
        switch progress {
        case 0..<0.3:
            color = .systemRed
        case 0.3..<0.7:
            color = .systemOrange
        default:
            color = .systemGreen
        }
        
        UIView.animate(withDuration: 0.3) {
            self.barColor = color
        }
    }
}

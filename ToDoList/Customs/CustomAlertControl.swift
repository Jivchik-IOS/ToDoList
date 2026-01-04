import UIKit

protocol CustomAlertControlDelegate: AnyObject {
    func didAddTask(task: String, difficulty: Difficulty)
    func didCancel()
}

class CustomAlertControl: UIView {
    
    weak var delegate: CustomAlertControlDelegate?
    private var selectedDifficulty: Difficulty = .easy
    
    private let containerView: UIView = {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.text = "Новая задача"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .label
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    lazy var taskField: UITextField = {
        $0.placeholder = "Введите название задачи"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .secondarySystemBackground
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.returnKeyType = .done
        $0.delegate = self
        
        return $0
    }(UITextField())
    
    private let difficultyLabel: UILabel = {
        $0.text = "Уровень сложности:"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    lazy var sgmtControl: UISegmentedControl = {
        $0.selectedSegmentIndex = 0
        $0.selectedSegmentTintColor = .systemOrange
        $0.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.systemOrange], for: .normal)
        $0.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UISegmentedControl(items: ["Легко", "Средне", "Трудно"]))
    
    private let difficultyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Легко: 1 день на выполнение"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIStackView())
    
    private lazy var cancelButton: UIButton = {
        $0.setTitle("Отмена", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(.secondaryLabel, for: .normal)
        $0.backgroundColor = .tertiarySystemBackground
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton(type: .system))
    
    private lazy var addButton: UIButton = {
        $0.setTitle("Добавить", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemOrange
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton(type: .system))
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - SetupUI
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(taskField)
        containerView.addSubview(difficultyLabel)
        containerView.addSubview(sgmtControl)
        containerView.addSubview(difficultyInfoLabel)
        containerView.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(addButton)
        
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
    }
    
    
    //MARK: Constr
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            taskField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            taskField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            taskField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            taskField.heightAnchor.constraint(equalToConstant: 44),
            
            difficultyLabel.topAnchor.constraint(equalTo: taskField.bottomAnchor, constant: 20),
            difficultyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            difficultyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            sgmtControl.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 12),
            sgmtControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            sgmtControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            sgmtControl.heightAnchor.constraint(equalToConstant: 36),
            
            difficultyInfoLabel.topAnchor.constraint(equalTo: sgmtControl.bottomAnchor, constant: 8),
            difficultyInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            difficultyInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            buttonsStackView.topAnchor.constraint(equalTo: difficultyInfoLabel.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - objcFunc
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedDifficulty = Difficulty(rawValue: sender.selectedSegmentIndex) ?? .easy
        
        switch selectedDifficulty {
        case .easy:
            difficultyInfoLabel.text = "Легко: 1 день на выполнение"
            difficultyInfoLabel.textColor = .systemGreen
        case .medium:
            difficultyInfoLabel.text = "Средне: 3 дня на выполнение"
            difficultyInfoLabel.textColor = .systemOrange
        case .hard:
            difficultyInfoLabel.text = "Трудно: 7 дней на выполнение"
            difficultyInfoLabel.textColor = .systemRed
        }
    }
    
    @objc private func cancelButtonTapped() {
        hideAlert()
        delegate?.didCancel()
    }
    
    @objc private func addButtonTapped() {
        guard let text = taskField.text?.trimmingCharacters(in: .whitespaces),
              !text.isEmpty else {
            shakeTextField()
            return
        }
        
        delegate?.didAddTask(task: text, difficulty: selectedDifficulty)
        hideAlert()
    }
    
    // MARK: - Animations
    func showAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.taskField.becomeFirstResponder()
        }
    }
    
    private func hideAlert() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.containerView.alpha = 0
            self.backgroundColor = .clear
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    private func shakeTextField() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        taskField.layer.add(animation, forKey: "shake")
    }
}


//MARK: Extensions
extension CustomAlertControl: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

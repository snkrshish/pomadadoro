import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: - Timer
    private var timer = Timer()
    private var time = 10 //время в секундах
    private var isWorkTimer = true
    private var isStarted = false

    //MARK: - Outlets

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = .darkGray
        label.text = "Работаем"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .green
        return label
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = formatText()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .black
        return label
    }()

    private lazy var timerButtom: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.imageView?.tintColor = .green
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside  )
        return button
    }()



    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupAutolayout()
    }


    //MARK: - Setup
    private func setupHierarchy() {
        view.addSubview(timerLabel)
        view.addSubview(timerButtom)
        view.addSubview(statusLabel)

    }

    private func setupAutolayout() {
        timerLabel.snp.makeConstraints {
            $0.center.equalTo(view)
        }

        timerButtom.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(view)
            $0.width.equalTo(timerButtom.snp.height)
            $0.height.equalTo(timerLabel.snp.height).offset(-25)
        }
        
        timerButtom.imageView?.snp.makeConstraints {
            $0.height.equalTo(timerButtom.snp.height)
            $0.width.equalTo(timerButtom.snp.width)
        }

        statusLabel.snp.makeConstraints{
            $0.height.greaterThanOrEqualTo(50)
            $0.centerX.equalTo(view)
            $0.top.equalTo(view).offset(100)
            $0.leading.equalTo(view).offset(80)
            $0.trailing.equalTo(view).offset(-80)
        }
    }
    //MARK: - Action
    @objc private func buttonPressed() {
        timerButtom.isEnabled = true
        if isWorkTimer{

            if !isStarted {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
                isStarted = true
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
            } else {
                timer.invalidate()
                isStarted = false
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
            }
        } else {
            if !isStarted {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
                isStarted = true
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
            } else {
                timer.invalidate()
                isStarted = false
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
                isWorkTimer = true
            }
        }
    }
    @objc private func timerMethod() {

        if isWorkTimer {
            if time > 0 {
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
                time -= 1
                timerLabel.text = formatText()
            } else {
                time = 5
                statusLabel.text = "Отдыхаем"
                statusLabel.textColor = .red
                timerLabel.text = formatText()
                timer.invalidate()
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
                timerButtom.imageView?.tintColor = .red
                isWorkTimer = false
                isStarted = false
            }
        } else {
            if time > 0 {
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
                time -= 1
                timerLabel.text = formatText()
            } else {
                time = 10
                statusLabel.text = "Работаем"
                statusLabel.textColor = .green
                timerLabel.text = formatText()
                timer.invalidate()
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
                timerButtom.imageView?.tintColor = .green
                isWorkTimer = true
                isStarted = false
            }
        }
    }

    private func formatText() -> String {
        let minute = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minute, seconds)
    }
}


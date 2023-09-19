import UIKit
import SnapKit

class ViewController: UIViewController {

    //MARK: - progressBar

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    //MARK: - Timer
    private var timer = Timer()
    private var time = 0 //время в секундах
    private var workTime = 10 // время работы
    private var chillTime = 5 // время отдыха
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
        time = workTime
        view.backgroundColor = .white
        createCircularPath()
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
                if progressLayer.timeOffset == 0 {
                    basicAnimation(duration: TimeInterval(time))
                } else {
                    resumeAnimation(layer: progressLayer)
                }
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
                isStarted = true
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
            } else {
                pauseAnimation(layer: progressLayer)
                timer.invalidate()
                isStarted = false
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
            }
        } else {
            if !isStarted {
                if progressLayer.timeOffset == 0 {
                    basicAnimation(duration: TimeInterval(time))
                } else {
                    resumeAnimation(layer: progressLayer)
                }
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
                isStarted = true
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
            } else {
                pauseAnimation(layer: progressLayer)
                timer.invalidate()
                isStarted = false
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
                isWorkTimer = true
            }
        }
    }
    @objc private func timerMethod() {
        if time > 1 {
            if isWorkTimer {
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
                time -= 1
                timerLabel.text = formatText()
            } else {
                timerButtom.setImage(UIImage(systemName: "pause"), for: .normal)
                time -= 1
                timerLabel.text = formatText()
            }
        } else {
            if isWorkTimer {
                timer.invalidate()
                time = chillTime
                statusLabel.text = "Отдыхаем"
                circleLayer.strokeColor = UIColor.red.cgColor
                statusLabel.textColor = .red
                timerLabel.text = formatText()
                timerButtom.setImage(UIImage(systemName: "play"), for: .normal)
                timerButtom.imageView?.tintColor = .red
                isWorkTimer = false
                isStarted = false
            } else {
                time = workTime
                statusLabel.text = "Работаем"
                circleLayer.strokeColor = UIColor.green.cgColor
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

    //MARK: - ProgressBar Function
    private func createCircularPath() {

        let circularPath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0), radius: 130,
                                        startAngle: startPoint,
                                        endAngle: endPoint,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 15.0
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = UIColor.green.cgColor
        view.layer.addSublayer(circleLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.speed = 1
        view.layer.addSublayer(progressLayer)
    }

    private func basicAnimation(duration: TimeInterval) {

        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "basicAnimation")
    }

    private func pauseAnimation(layer : CALayer){
        let pausedTime : CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    private func resumeAnimation(layer : CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 1
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}


import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: - Outlets

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
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
    }
    //MARK: - Action
    @objc private func buttonPressed() {

    }
}


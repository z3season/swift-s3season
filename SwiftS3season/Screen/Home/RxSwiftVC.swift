//
//  RxSwiftVC.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/28.
//

import UIKit
import SnapKit
import RxSwift

class RxSwiftVC: BaseViewController {
    
    // 创建deinit属性，也就是所有者要释放的时候，自动取消监听
    fileprivate lazy var disposeBag = DisposeBag()

    let minimalUsernameLength: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RxSwift"
        layoutView()
        valid()
    }
        
    func valid() {
        
        let accountValid = accountInput.rx.text.orEmpty
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1)
        
        accountValid.bind(to: passwordInput.rx.isEnabled)
            .disposed(by: self.disposeBag)
        accountValid.bind(to: accountLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        let passwordValid = passwordInput.rx.text.orEmpty
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1)
        passwordValid.bind(to: passwordLabel.rx.isHidden)
            .disposed(by: self.disposeBag)

        let everythingValid = Observable.combineLatest(
            accountValid,
            passwordValid
        ) {$0 && $1}.replay(1)
        
        everythingValid.bind(to: submitBtn.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        submitBtn.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.showAlert()
            }) .disposed(by: self.disposeBag)
    }
    
    func showAlert() {
        let alertView = UIAlertView(
            title: "提示",
            message: "登录成功",
            delegate: nil,
            cancelButtonTitle: "好"
        )
        alertView.show()
    }

    // MARK: layout
    private func layoutView() {
        self.view.addSubview(self.accountInput)
        self.view.addSubview(self.accountLabel)
        self.view.addSubview(self.passwordInput)
        self.view.addSubview(self.passwordLabel)
        self.view.addSubview(self.submitBtn)
        self.accountInput.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(40)
        }
        self.accountLabel.snp.makeConstraints { make in
            make.left.height.right.equalTo(self.accountInput)
            make.top.equalTo(self.accountInput.snp.bottom).offset(3)
        }
        self.passwordInput.snp.makeConstraints { make in
            make.left.height.right.equalTo(self.accountLabel)
            make.top.equalTo(self.accountLabel.snp.bottom).offset(10)
        }
        self.passwordLabel.snp.makeConstraints { make in
            make.left.height.right.equalTo(self.passwordInput)
            make.top.equalTo(self.passwordInput.snp.bottom).offset(3)
        }
        self.submitBtn.snp.makeConstraints { make in
            make.left.height.right.equalTo(self.passwordLabel)
            make.top.equalTo(self.passwordLabel.snp.bottom).offset(10)
        }
    }
    
    // MARK: lazy
    lazy var accountInput: UITextField = {
        let input = UITextField.init(frame: CGRect.zero)
        input.backgroundColor = .white
        input.textColor = UIColor(hex: "#111111")
        input.placeholder = "请输入账号"
        input.addLeftTextPadding(10)
        input.attributedPlaceholder = NSAttributedString.init(string:"请输入账号", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "#999999"), NSAttributedString.Key.font: UIFont.systemFont(ofSize:15)])
        input.layer.cornerRadius = 8
        input.layer.masksToBounds = true
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor(hex: "#f3f3f3").cgColor
        return input
    }()
    lazy var accountLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor(hex: "#FF0015")
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "账号必须不低于5个字符"
        return label
    }()
    
    lazy var passwordInput: UITextField = {
        let input = UITextField.init(frame: CGRect.zero)
        input.backgroundColor = .white
        input.textColor = UIColor(hex: "#111111")
        input.attributedPlaceholder = NSAttributedString.init(string:"请输入密码", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "#999999"), NSAttributedString.Key.font: UIFont.systemFont(ofSize:15)])
        input.layer.cornerRadius = 8
        input.addLeftTextPadding(10)
        input.layer.masksToBounds = true
        input.borderStyle = .roundedRect
        input.layer.borderWidth = 0.5
        input.layer.borderColor = UIColor(hex: "#f3f3f3").cgColor
        return input
    }()
    lazy var passwordLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor(hex: "#FF0015")
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "密码必须不低于6个字符"
        return label
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("登录", for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor(hex: "#ffdd07")
        btn .setTitleColor(UIColor(hex: "#111111"), for: .normal)
        return btn
    }()
    
}

extension UITextField {
 
    /// 添加左内边距
    public func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
 
    /// 在文本框的左边添加一个图标
    public func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
 
}

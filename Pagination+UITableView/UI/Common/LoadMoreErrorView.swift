//
//  LoadMoreErrorView.swift
//  Pagination+UITableView
//
//  Created by Igor on 30.11.2021.
//

import UIKit

final class LoadMoreErrorView: UIView {
    
    private lazy var reSendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 0.5)
        
        let attributedString = NSMutableAttributedString(string: "Ошибка соединения.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: " Повторить", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(reSendAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    public var resendButtonTapped: (() -> Void)?
    
    
    init(frame: CGRect, resendButtonTapped: @escaping (() -> Void)) {
        super.init(frame: frame)
        self.resendButtonTapped = resendButtonTapped
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reSendButton.layer.cornerRadius = 21
    }
    
    
    func initView() {
        
        addSubview(reSendButton)
        reSendButton.widthAnchor.constraint(equalToConstant: 262).isActive = true
        reSendButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        reSendButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        reSendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc func reSendAction() {
        resendButtonTapped?()
    }
}
